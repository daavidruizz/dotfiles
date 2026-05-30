#!/usr/bin/env python3
import json
import subprocess
import threading

import gi
gi.require_version('Gtk', '3.0')
gi.require_version('GdkPixbuf', '2.0')
gi.require_version('Pango', '1.0')
gi.require_version('GtkLayerShell', '0.1')
from gi.repository import Gtk, GdkPixbuf, GLib, Gdk, Pango, GtkLayerShell

THUMB_SIZE = 80
WINDOW_W   = 340
WINDOW_H   = 480
WAYBAR_H   = 46   # altura de la waybar en píxeles

CSS = b"""
window {
    background-color: @theme_bg_color;
    border-radius: 12px;
    border: 1px solid alpha(@theme_fg_color, 0.12);
}
scrolledwindow {
    margin: 6px;
}
listbox {
    background: transparent;
}
row {
    border-radius: 6px;
    margin: 1px 2px;
}
row:nth-child(even) {
    background: alpha(@theme_fg_color, 0.05);
}
row:hover {
    background: alpha(@theme_selected_bg_color, 0.3);
}
row:selected, row:active {
    background: @theme_selected_bg_color;
    color: @theme_selected_fg_color;
}
.entry-text { font-size: 13px; }
.img-label {
    font-size: 11px;
    font-style: italic;
    color: alpha(@theme_fg_color, 0.5);
}
"""

# ── helpers ────────────────────────────────────────────────────────────────

def clip_list():
    r = subprocess.run(['cliphist', 'list'], capture_output=True)
    return r.stdout.decode('utf-8', errors='replace').splitlines() if r.returncode == 0 else []

def clip_decode(line: str) -> bytes:
    r = subprocess.run(['cliphist', 'decode'], input=line.encode(), capture_output=True)
    return r.stdout

def is_binary(line: str) -> bool:
    """Detecta entradas binarias (imágenes u otros) por el marcador de cliphist."""
    content = line.split('\t', 1)[-1] if '\t' in line else line
    low = content.lower()
    return 'binary' in low or 'image/' in low

def try_pixbuf(data: bytes):
    """Intenta cargar bytes como imagen. Devuelve Pixbuf o None."""
    try:
        loader = GdkPixbuf.PixbufLoader()
        loader.write(data)
        loader.close()
        return loader.get_pixbuf()
    except Exception:
        return None

def scale_pixbuf(pb, size: int):
    w, h = pb.get_width(), pb.get_height()
    scale = size / max(w, h)
    return pb.scale_simple(int(w * scale), int(h * scale), GdkPixbuf.InterpType.BILINEAR)

def get_cursor_x() -> int | None:
    try:
        r = subprocess.run(['hyprctl', 'cursorpos', '-j'], capture_output=True, text=True, timeout=1)
        return json.loads(r.stdout)['x']
    except Exception:
        return None

def get_monitor_width() -> int:
    try:
        r = subprocess.run(['hyprctl', 'monitors', '-j'], capture_output=True, text=True, timeout=1)
        for m in json.loads(r.stdout):
            if m.get('focused'):
                return m['width']
    except Exception:
        pass
    return 1920

def do_copy(line: str, close_cb):
    data = clip_decode(line)
    proc = subprocess.Popen(['wl-copy'], stdin=subprocess.PIPE)
    proc.communicate(data)
    GLib.idle_add(close_cb)

# ── ventanas ───────────────────────────────────────────────────────────────

class Backdrop(Gtk.Window):
    """Capa transparente fullscreen: cierra el picker al hacer click fuera."""

    def __init__(self, close_cb):
        super().__init__()
        GtkLayerShell.init_for_window(self)
        GtkLayerShell.set_layer(self, GtkLayerShell.Layer.TOP)
        for edge in (GtkLayerShell.Edge.TOP, GtkLayerShell.Edge.BOTTOM,
                     GtkLayerShell.Edge.LEFT, GtkLayerShell.Edge.RIGHT):
            GtkLayerShell.set_anchor(self, edge, True)
        GtkLayerShell.set_exclusive_zone(self, -1)
        self.set_app_paintable(True)
        self.set_opacity(0.0)
        self.add_events(Gdk.EventMask.BUTTON_PRESS_MASK)
        self.connect('button-press-event', lambda *_: close_cb())
        self.show_all()


class ClipPicker(Gtk.Window):

    def __init__(self, close_cb):
        super().__init__()
        self._close = close_cb
        self.set_title('clipboard-picker')
        self.set_default_size(WINDOW_W, WINDOW_H)
        self.set_resizable(False)

        # layer shell: OVERLAY (encima del backdrop TOP)
        GtkLayerShell.init_for_window(self)
        GtkLayerShell.set_layer(self, GtkLayerShell.Layer.OVERLAY)
        GtkLayerShell.set_anchor(self, GtkLayerShell.Edge.TOP, True)
        GtkLayerShell.set_margin(self, GtkLayerShell.Edge.TOP, WAYBAR_H)
        GtkLayerShell.set_keyboard_mode(self, GtkLayerShell.KeyboardMode.EXCLUSIVE)

        # posición horizontal centrada en el cursor
        cx = get_cursor_x()
        mw = get_monitor_width()
        if cx is not None:
            left = max(0, min(cx - WINDOW_W // 2, mw - WINDOW_W))
            GtkLayerShell.set_anchor(self, GtkLayerShell.Edge.LEFT, True)
            GtkLayerShell.set_margin(self, GtkLayerShell.Edge.LEFT, left)
        else:
            GtkLayerShell.set_anchor(self, GtkLayerShell.Edge.RIGHT, True)
            GtkLayerShell.set_margin(self, GtkLayerShell.Edge.RIGHT, 8)

        # CSS
        prov = Gtk.CssProvider()
        prov.load_from_data(CSS)
        Gtk.StyleContext.add_provider_for_screen(
            Gdk.Screen.get_default(), prov,
            Gtk.STYLE_PROVIDER_PRIORITY_APPLICATION
        )

        # widgets
        scroll = Gtk.ScrolledWindow()
        scroll.set_policy(Gtk.PolicyType.NEVER, Gtk.PolicyType.AUTOMATIC)
        self.listbox = Gtk.ListBox()
        self.listbox.set_selection_mode(Gtk.SelectionMode.SINGLE)
        self.listbox.connect('row-activated', self._activated)
        scroll.add(self.listbox)
        self.add(scroll)

        self.connect('key-press-event', self._key)
        self.show_all()

        threading.Thread(target=self._load_entries, daemon=True).start()

    # ── carga ──────────────────────────────────────────────────────────

    def _load_entries(self):
        for line in clip_list():
            GLib.idle_add(self._add_row, line)

    def _add_row(self, line: str):
        row = Gtk.ListBoxRow()
        row.line = line

        box = Gtk.Box(orientation=Gtk.Orientation.HORIZONTAL, spacing=10)
        box.set_margin_start(10)
        box.set_margin_end(10)
        box.set_margin_top(6)
        box.set_margin_bottom(6)

        if is_binary(line):
            img = Gtk.Image()
            img.set_size_request(THUMB_SIZE, THUMB_SIZE)
            img.set_from_icon_name('image-x-generic', Gtk.IconSize.DIALOG)
            box.pack_start(img, False, False, 0)

            lbl = Gtk.Label(label='cargando…')
            lbl.set_halign(Gtk.Align.START)
            lbl.get_style_context().add_class('img-label')
            box.pack_start(lbl, True, True, 0)

            threading.Thread(target=self._load_thumb, args=(line, img, lbl), daemon=True).start()
        else:
            text = line.split('\t', 1)[-1].strip()
            lbl = Gtk.Label(label=text)
            lbl.set_halign(Gtk.Align.START)
            lbl.set_ellipsize(Pango.EllipsizeMode.END)
            lbl.set_max_width_chars(36)
            lbl.set_lines(2)
            lbl.set_line_wrap(True)
            lbl.set_line_wrap_mode(Pango.WrapMode.WORD_CHAR)
            lbl.get_style_context().add_class('entry-text')
            box.pack_start(lbl, True, True, 0)

        row.add(box)
        self.listbox.add(row)
        row.show_all()

    def _load_thumb(self, line: str, img_widget, lbl_widget):
        data = clip_decode(line)
        pb = try_pixbuf(data)
        if pb:
            pb = scale_pixbuf(pb, THUMB_SIZE)
            GLib.idle_add(img_widget.set_from_pixbuf, pb)
            GLib.idle_add(lbl_widget.set_text, '')
        else:
            GLib.idle_add(img_widget.set_from_icon_name, 'application-x-generic', Gtk.IconSize.DIALOG)
            GLib.idle_add(lbl_widget.set_text, 'datos binarios')

    # ── eventos ────────────────────────────────────────────────────────

    def _activated(self, _lb, row):
        threading.Thread(target=do_copy, args=(row.line, self._close), daemon=True).start()

    def _key(self, _w, event):
        if event.keyval == Gdk.KEY_Escape:
            self._close()


# ── main ───────────────────────────────────────────────────────────────────

def main():
    wins = []

    def close_all():
        for w in wins:
            try:
                w.destroy()
            except Exception:
                pass
        Gtk.main_quit()

    wins.append(Backdrop(close_all))
    wins.append(ClipPicker(close_all))
    Gtk.main()


if __name__ == '__main__':
    main()
