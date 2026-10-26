local status, gruvbox = pcall(require, 'gruvbox')
if (not status) then return end

-- Config: https://github.com/ellisonleao/gruvbox.nvim

gruvbox.setup({
  undercurl = true,
  underline = true,
  italic = {
    strings = false
  }
})

vim.cmd("colorscheme gruvbox")
