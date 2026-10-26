-- Gitgutter
vim.cmd([[let g:gitgutter_enabled = 1]])
vim.cmd([[let g:gitgutter_map_keys = 0]])

vim.keymap.set('n', ')', '<Plug>(GitGutterNextHunk)')
vim.keymap.set('n', '(', '<Plug>(GitGutterPrevHunk)')
