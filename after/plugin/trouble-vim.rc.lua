local trouble = require("trouble")

trouble.setup {
  -- your configuration comes here
}

local opts = { silent = true, noremap = false }

vim.keymap.set("n", "<leader>xx", "<cmd>Trouble diagnostics toggle<CR>", opts)
vim.keymap.set("n", "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<CR>", opts)
vim.keymap.set("n", "<leader>xs", "<cmd>Trouble symbols toggle focus=false<CR>", opts)
vim.keymap.set("n", "<leader>xl", "<cmd>Trouble lsp toggle focus=false win.position=right<CR>", opts)
vim.keymap.set("n", "<leader>xL", "<cmd>Trouble loclist toggle<CR>", opts)
vim.keymap.set("n", "<leader>xQ", "<cmd>Trouble qflist toggle<CR>", opts)

