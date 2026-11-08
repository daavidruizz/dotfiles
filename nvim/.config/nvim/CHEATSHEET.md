# Chuleta de Neovim (LazyVim)

Atajos de mi configuración (LazyVim + clangd + blink.cmp), con teclado en español.
`Espacio` es la tecla líder. Salvo que se indique otra cosa, todo es en **modo normal** (pulsa `Esc` antes).

> **Si no recuerdas un atajo:** pulsa `Espacio` (o `g`, `]`, `[`…) y **espera**: which-key enseña el menú.
> **Si vim hace cosas raras:** pulsa `Esc` y mira abajo a la izquierda en qué modo estás.

---

## 1. Modos y estados

| Lo que pone abajo | Qué significa | Cómo salir |
|---|---|---|
| `NORMAL` | Modo de órdenes (moverse, borrar, copiar…) | — |
| `INSERT` | Escribiendo texto | `Esc` |
| `VISUAL` / `V-LINE` | Seleccionando (`v` caracteres, `V` líneas) | `Esc` |
| `SELECT` | Hueco de snippet seleccionado: lo que escribas lo sustituye | Escribe o `Tab` al siguiente hueco |
| `O-PENDING` | Has pulsado un operador (`d`, `c`, `y`…) y espera un movimiento | `Esc` para cancelar |
| `recording @w` (a la derecha) | Grabando una macro (se activa con `q` + letra). **Desactiva el menú de `Espacio`** | `q` |

---

## 2. Deshacer, rehacer e historial

| Tecla | Qué hace |
|---|---|
| `u` | Deshacer |
| `Ctrl+r` | Rehacer |
| `5u` | Deshacer 5 cambios |
| `Espacio su` | Historial de cambios (undotree) con vista previa |
| `.` | Repetir el último cambio |

- Todo lo escrito en una misma entrada en modo insertar cuenta como **un** cambio.
- El historial se guarda al cerrar el archivo (`undofile`).
- Evita `U` mayúscula: no es rehacer.

---

## 3. Moverse en horizontal (por la línea)

| Tecla | Movimiento |
|---|---|
| `h` / `l` | Un carácter izquierda / derecha |
| `w` / `b` | Inicio de la palabra siguiente / anterior |
| `e` | Final de la palabra |
| `W` / `B` / `E` | Igual, con "palabras grandes" (solo separadas por espacios) |
| `0` / `$` | Principio / final de la línea |
| `^` | Primer carácter que no es espacio |
| `f` + letra | Saltar **a** esa letra (`f(` → al paréntesis) |
| `t` + letra | Saltar **justo antes** de esa letra |
| `F` / `T` + letra | Igual, hacia la izquierda |
| `;` / `,` | Repetir el último `f`/`t` adelante / atrás |
| `3w` | Cualquier movimiento con número delante se repite |

---

## 4. Moverse en vertical (por el archivo)

| Tecla | Movimiento |
|---|---|
| `j` / `k` | Línea abajo / arriba |
| `5j` / `5k` | 5 líneas (mira los números relativos del margen) |
| `Ctrl+d` / `Ctrl+u` | Media pantalla abajo / arriba |
| `Ctrl+f` / `Ctrl+b` | Pantalla completa abajo / arriba |
| `gg` / `G` | Principio / final del archivo |
| `120G` o `:120` | Ir a la línea 120 (útil con los errores del compilador) |
| `{` / `}` | Bloque anterior / siguiente (salta entre líneas en blanco) |
| `%` | De una `{` `(` `[` a su pareja |
| `]f` / `[f` | Función siguiente / anterior (treesitter) |
| `zz` | Centrar la pantalla en el cursor |
| `Ctrl+o` / `Ctrl+i` | Volver atrás / adelante tras cualquier salto |

---

## 5. Buscar y saltar

| Tecla | Qué hace |
|---|---|
| `/texto` + `Enter` | Buscar hacia abajo |
| `n` / `N` | Siguiente / anterior resultado |
| `*` / `#` | Buscar la palabra bajo el cursor hacia abajo / arriba |
| `]]` / `[[` | Siguiente / anterior uso de la variable bajo el cursor (clangd, solo usos reales) |
| `gr` | Lista de todos los usos de la variable / función (en todo el proyecto) |
| `s` + 2 letras | **Flash**: saltar a cualquier sitio visible pulsando su etiqueta |
| `Espacio Espacio` | Buscar archivos del proyecto |
| `Espacio /` | Buscar **texto** en todo el proyecto |
| `Espacio ss` | Funciones / símbolos del archivo actual |
| `Espacio sS` | Símbolos de todo el proyecto (los que conoce clangd) |
| `Espacio s"` | Ver los registros (portapapeles de vim) |

---

## 6. Editar: operadores + movimientos

Un **operador** seguido de un **movimiento** u **objeto de texto**:

| Operador | Qué hace |
|---|---|
| `d` | Borrar (**corta**: va al portapapeles) |
| `c` | Cambiar (borra y entra en modo insertar) |
| `y` | Copiar |
| `>` / `<` | Indentar / desindentar |
| `gc` | Comentar / descomentar |

| Ejemplo | Qué hace |
|---|---|
| `dd` / `yy` / `cc` | Borrar / copiar / cambiar la línea entera |
| `5dd` | Borrar 5 líneas |
| `dw` / `cw` | Borrar / cambiar una palabra |
| `d$` / `c$` | Hasta el final de la línea |
| `dt)` / `ct,` | Hasta antes del `)` / de la `,` |
| `d}` | Hasta la siguiente línea en blanco |
| `dG` | Hasta el final del archivo |
| `x` | Borrar el carácter bajo el cursor (como `Supr`) |
| `X` | Borrar el carácter de la izquierda (como `Backspace`) |
| `J` | Unir la línea de abajo con la actual |
| `>>` / `<<` | Indentar / desindentar la línea (4 espacios) |

**Cuidado:** `d` sola no hace nada visible, se queda esperando (`O-PENDING`). Si después pulsas `h`, `←`, `Backspace` o `Espacio`, borra un carácter. Para cancelar: `Esc`.

---

## 7. Objetos de texto (los más útiles en C)

Se usan detrás de un operador: `d`, `c`, `y`, `v`, `gc`…

| Objeto | Qué selecciona | Ejemplo |
|---|---|---|
| `i{` / `a{` | Dentro de las llaves / incluyendo las llaves | `di{` vacía el cuerpo de una función o un `if` |
| `i(` / `a(` | Dentro de los paréntesis / incluyéndolos | `ci(` reescribe los argumentos |
| `ia` / `aa` | Un argumento / un argumento con su coma (mini.ai) | `cia` cambia un argumento, `daa` lo quita |
| `iw` / `aw` | Palabra | `ciw` cambia la palabra entera |
| `i"` / `a"` | Dentro de las comillas | `ci"` cambia un string |
| `ap` | Párrafo / bloque | `dap` borra el bloque |

`Vi{` (o `via`, `vi(`…) selecciona para ver qué vas a tocar antes de actuar.

---

## 8. Seleccionar (modo visual)

| Tecla | Qué hace |
|---|---|
| `v` | Selección por caracteres |
| `V` | Selección por líneas |
| `Ctrl+v` | Selección en bloque (columnas) |
| Con selección: `d` / `y` / `c` | Borrar / copiar / cambiar |
| Con selección: `>` / `<` | Indentar / desindentar |
| Con selección: `gc` | Comentar / descomentar |
| Con selección: `P` | Pegar encima **sin perder** lo copiado |

---

## 9. Copiar, pegar y portapapeles

Mi config usa `clipboard=unnamedplus`: copiar y borrar en nvim va al portapapeles del sistema.

| Tecla | Qué hace |
|---|---|
| `y` + movimiento | Copiar |
| `p` / `P` | Pegar después / antes del cursor |
| `"_d` + movimiento | Borrar **sin** copiar (registro "agujero negro") |
| `"_dd` | Borrar la línea sin copiarla |
| `"0p` | Pegar lo último **copiado** (aunque después hayas borrado algo) |
| `Espacio s"` | Ver todos los registros y pegar uno |
| `:reg` | Ver los registros en texto plano |

| Registro | Contenido |
|---|---|
| `+` | Portapapeles del sistema |
| `0` | Lo último copiado con `y` |
| `1`–`9` | Últimos borrados de líneas enteras |
| `a`–`z` | Registros con nombre / macros |

---

## 10. Reemplazar

| Comando | Qué hace |
|---|---|
| `Espacio cr` | Renombrar variable / función **en todo el proyecto** (clangd). Lo más seguro |
| `:%s/viejo/nuevo/g` | Reemplazar en todo el archivo |
| `:%s/viejo/nuevo/gc` | Igual, preguntando una a una (`y` / `n`) |
| `V` + selección + `:s/viejo/nuevo/g` | Solo en las líneas seleccionadas |
| `Espacio sr` | Buscar y reemplazar en todo el proyecto, con vista previa |
| `*` → `cgn` → texto → `Esc` → `.` `.` `.` | Cambiar las apariciones de una palabra una a una |

---

## 11. Mover y comentar líneas

| Tecla | Qué hace |
|---|---|
| `Alt+j` / `Alt+k` | Mover la línea (o la selección) abajo / arriba. Funciona en normal, visual e insertar |
| `gcc` | Comentar / descomentar la línea |
| `3gcc` | Comentar 3 líneas |
| `V` + mover + `gc` | Comentar la selección |
| `gcap` | Comentar el bloque |
| `gci{` | Comentar todo lo de dentro de las llaves |
| `gco` / `gcO` | Nueva línea de comentario debajo / encima |

Si al pulsar `Enter` en un comentario aparece un `//` que no quieres: `Ctrl+w` (en modo insertar) lo borra.

---

## 12. Código: LSP / clangd

| Tecla | Qué hace |
|---|---|
| `K` | Documentación / firma de lo que hay bajo el cursor (`K` otra vez para entrar, `q` para salir). Con macros enseña su valor expandido |
| `Ctrl+k` (insertar) | Firma de la función mientras escribes los argumentos |
| `gd` | Ir a la definición |
| `gD` | Ir a la declaración |
| `gr` | Ver dónde se usa (referencias) |
| `gI` | Ir a la implementación |
| `gy` | Ir a la definición del tipo |
| `Ctrl+o` | Volver de donde venías |
| `:Man 3 strcpy` | Página del manual de una función de C (requiere `man-pages`) |

**Menú `Espacio c` (código):**

| Tecla | Qué hace |
|---|---|
| `Espacio ca` | Acciones de código: arreglos rápidos para la línea (añadir `#include`, corregir nombre…) |
| `Espacio cA` | Acciones para el archivo entero |
| `Espacio cr` | Renombrar en todo el proyecto |
| `Espacio cd` | Ver completo el error / aviso de la línea |
| `Espacio cf` | Formatear (clang-format; también se hace solo al guardar) |
| `Espacio ch` | Saltar entre `.c` y `.h` |
| `Espacio cs` | Lista de símbolos (Trouble) |
| `Espacio cl` | Info del LSP activo |
| `Espacio cm` | Mason (instalar herramientas) |
| `Espacio cp` | Selector de color (ccc) |

---

## 13. Errores y avisos (diagnósticos)

| Tecla | Qué hace |
|---|---|
| `]d` / `[d` | Siguiente / anterior error **o** aviso |
| `]e` / `[e` | Solo errores |
| `]w` / `[w` | Solo avisos (*warnings*) |
| `Espacio xx` | Panel con todos los errores del archivo (Trouble) |
| `Espacio cd` | Mensaje completo del error de la línea |

Teclado español: `[` y `]` se escriben con `AltGr` + las dos teclas a la derecha de la `P` (la del acento grave y la del `+`).

> Cuando el compilador dice `expected ...` en una línea, el fallo suele estar **justo antes**.

---

## 14. Autocompletado (blink.cmp)

| Tecla | Qué hace |
|---|---|
| `Ctrl+n` / `Ctrl+p` (o flechas) | Moverse por la lista |
| `Enter` | Aceptar la sugerencia (sustituye la palabra entera) |
| `Ctrl+Espacio` | Abrir el menú a mano |
| `Ctrl+e` | Cerrar el menú **sin salir** de modo insertar |
| `Esc` | Cerrar el menú **y salir** de modo insertar |

**Huecos de los argumentos (snippets de clangd):**

| Tecla | Qué hace |
|---|---|
| Escribir | Sustituye el hueco seleccionado (`SELECT`) |
| `Tab` | Siguiente hueco |
| `Shift+Tab` | Hueco anterior |

No muevas el cursor ni pulses `Esc` a mitad: te sales del snippet y los nombres de los parámetros se quedan escritos. Arreglo: `cia` sobre cada uno.

Iconos de la lista: `abc` = palabra del archivo (buffer); `ƒ`, campo, variable… = clangd.

---

## 15. Terminal

| Tecla | Qué hace |
|---|---|
| `Espacio ft` | Terminal flotante en la raíz del proyecto |
| `Espacio fT` | Terminal flotante en la carpeta actual |
| `Esc Esc` y luego `q` | Ocultar la terminal (sigue viva; se recupera con `Espacio ft`) |
| `exit` | Cerrarla del todo |

`Ctrl+/` es el atajo original de LazyVim, pero con teclado español no se puede pulsar (la `/` es `Shift+7`).

---

## 16. Interfaz y menús

| Tecla | Qué hace |
|---|---|
| `Espacio` (y esperar) | Menú de atajos (which-key) |
| `Espacio e` | Árbol de archivos (Neo-tree) |
| `Espacio uC` | Elegir tema con vista previa (temporal) |
| `Espacio gg` | Lazygit |
| `Espacio gn` | Neogit |
| `:LazyExtras` | Activar extras (lenguajes, herramientas) |
| `:Lazy` | Gestor de plugins |
| `:Mason` | Instalar LSP / formateadores |
| `:checkhealth vim.lsp` | Comprobar qué LSP está activo |

Grupos del menú: `Espacio s` = buscar (*search*) · `Espacio u` = interfaz (*UI*) · `Espacio c` = código · `Espacio g` = git · `Espacio x` = diagnósticos · `Espacio f` = archivos / terminal.

---

## 17. Macros

| Tecla | Qué hace |
|---|---|
| `q` + letra | Empezar a grabar en ese registro (`qw`) |
| `q` | Parar de grabar |
| `@` + letra | Ejecutar la macro (`@w`) |
| `@@` | Repetir la última macro |

Si ves `recording @letra` abajo sin querer: pulsa `q`.

---

## 18. Formateador (clang-format)

- Se aplica solo **al guardar**. Estilo: LLVM + llaves Allman, 4 espacios, 120 columnas, sin reescribir comentarios.
- Para que no toque un trozo:

```c
// clang-format off
...
// clang-format on
```
