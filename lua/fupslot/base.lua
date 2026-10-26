vim.cmd("autocmd!")

vim.scriptencoding = 'utf-8'
vim.wo.number = true
vim.wo.relativenumber = true


-- disable netrw at the very start of your init.lua
-- Note: Required by "nvim-tree"
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- disabled providers
vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_node_provider = 0

vim.g.tmux_navigator_disable_when_zoomed = 1

vim.opt.encoding = 'utf-8'
vim.opt.fileencoding = 'utf-8'
vim.opt.title = true
vim.opt.signcolumn = 'yes'
vim.opt.updatetime = 100
vim.opt.autoindent = true
vim.opt.smartindent = true

vim.opt.hlsearch = true
vim.opt.incsearch = true

vim.opt.backup = false
vim.opt.swapfile = false
-- Undo history lives in the default 'undodir' (stdpath("state")/undo), outside
-- the config directory, since it holds full contents of every edited file.
vim.opt.undofile = true

vim.opt.showcmd = true
vim.opt.cmdheight = 1
vim.opt.laststatus = 2
vim.opt.scrolloff = 10
vim.opt.shell = 'zsh'
vim.opt.backupskip = { '/tmp/*', '/private/tmp/*' }
vim.opt.inccommand = 'split'
vim.opt.ignorecase = true -- Case insensitive searching UNLESS /C or capital in search
vim.opt.smarttab = true
vim.opt.breakindent = true

vim.opt.autowrite = true
vim.opt.autoread = true

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.shiftround = true
vim.opt.expandtab = true

vim.opt.wrap = false
vim.opt.backspace = { 'start', 'eol', 'indent' }
vim.opt.path:append { '**' } -- Finding files - Search down into subfolders
vim.opt.wildignore:append { '*/node_modules/*', '*/.git/*', '*/.DS_Store', '*/.venv/*', '*/venv/*' }
--vim.opt.guitablabel = '%N'

-- split windows
vim.opt.splitright = true
vim.opt.splitbelow = true

-- clipboard
vim.opt.clipboard:append { 'unnamedplus' }

-- Undercurl
vim.cmd([[let &t_Cs = "\e[4:3m"]])
vim.cmd([[let &t_Ce = "\e[4:0m"]])

-- Turn off paste mode when leaving insert
vim.api.nvim_create_autocmd("InsertLeave", {
  pattern = '*',
  command = "set nopaste"
})

-- Highlight
vim.opt.cursorline = true
vim.opt.termguicolors = true
vim.opt.winblend = 0
vim.opt.wildoptions = 'pum'
vim.opt.pumblend = 5
vim.opt.background = 'dark'
vim.opt.colorcolumn = '120'

-- highlight yanked text for 200ms using the "Visual" highlight group
vim.cmd [[
  augroup highlight_yank
  autocmd!
  au TextYankPost * silent! lua vim.highlight.on_yank({higroup="Visual", timeout=100})
  augroup END
]]

-- Add asterisks in block comments
vim.opt.formatoptions:append { 'r' }

-- Transparent background
vim.api.nvim_set_hl(0, 'Normal', { bg = 'none' })
vim.api.nvim_set_hl(0, 'NormalFloat', { bg = 'none' })

-- Strip background from nvim-web-devicons so file-type icons inherit the
-- transparent bg instead of rendering as colored blocks (notably in bufferline).
local function clear_devicon_bg()
  for _, group in ipairs(vim.fn.getcompletion('DevIcon', 'highlight')) do
    vim.api.nvim_set_hl(0, group, { bg = 'NONE' })
  end
end
vim.api.nvim_create_autocmd('ColorScheme', { callback = clear_devicon_bg })
clear_devicon_bg()

