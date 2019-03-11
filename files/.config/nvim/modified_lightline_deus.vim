" =============================================================================
" Filename: autoload/lightline/colorscheme/deus.vim
" Author: nikersify
" License: MIT License
" Last Change: 2018/01/24 13:26:00
" =============================================================================

let s:term_red = 204
let s:term_green = 114
let s:term_yellow = 180
let s:term_blue = 39
let s:term_purple = 170
let s:term_white = 145
let s:term_black = 235
let s:term_grey = 236

let s:p = {'normal': {}, 'inactive': {}, 'insert': {}, 'replace': {}, 'visual': {}, 'tabline': {}}

let s:p.normal.left = [ [ '#1e272b', '#98c379', s:term_black, s:term_green, 'bold' ], [ '#98c379', '#1e272b', s:term_green, s:term_black ] ]
let s:p.normal.right = [ [ '#1e272b', '#98c379', s:term_black, s:term_green ], [ '#1e272b', '#78824b', s:term_white, s:term_grey ], [ '#98c379', '#1e272b', s:term_green, s:term_black ] ]
let s:p.inactive.right = [ [ '#1e272b', '#ead49b', s:term_black, s:term_blue], [ '#1e272b', '#78824b', s:term_white, s:term_grey ] ]
let s:p.inactive.left = s:p.inactive.right[1:]
" her
let s:p.insert.left = [ [ '#1e272b', '#ead49b', s:term_black, s:term_blue, 'bold' ], [ '#ead49b', '#1e272b', s:term_blue, s:term_black ] ]
let s:p.insert.right = [ [ '#1e272b', '#ead49b', s:term_black, s:term_blue ], [ '#1e272b', '#78824b', s:term_white, s:term_grey ], [ '#ead49b', '#1e272b', s:term_blue, s:term_black ] ]
let s:p.replace.left = [ [ '#1e272b', '#e06c75', s:term_black, s:term_red, 'bold' ], [ '#e06c75', '#1e272b', s:term_red, s:term_black ] ]
let s:p.replace.right = [ [ '#1e272b', '#e06c75', s:term_black, s:term_red, 'bold' ], s:p.normal.right[1], [ '#e06c75', '#1e272b', s:term_red, s:term_black ] ]
let s:p.visual.left = [ [ '#1e272b', '#af545b', s:term_black, s:term_purple, 'bold' ], [ '#af545b', '#1e272b', s:term_purple, s:term_black ] ]
let s:p.visual.right = [ [ '#1e272b', '#af545b', s:term_black, s:term_purple, 'bold' ], s:p.normal.right[1], [ '#af545b', '#1e272b', s:term_purple, s:term_black ] ]
let s:p.normal.middle = [ [ '#1e272b', '#1e272b', s:term_white, s:term_black ] ]
let s:p.insert.middle = s:p.normal.middle
let s:p.replace.middle = s:p.normal.middle
let s:p.tabline.left = [ s:p.normal.left[1] ]
let s:p.tabline.tabsel = [ s:p.normal.left[0] ]
let s:p.tabline.middle = s:p.normal.middle
let s:p.tabline.right = [ s:p.normal.left[1] ]
let s:p.normal.error = [ [ '#1e272b', '#e06c75', s:term_black, s:term_red ] ]
let s:p.normal.warning = [ [ '#1e272b', '#e5c07b', s:term_black, s:term_yellow ] ]

let g:lightline#colorscheme#deus#palette = lightline#colorscheme#fill(s:p)
