local setup, tree = pcall(require, 'nvim-tree')
if (not setup) then return end


tree.setup({
  sort_by = "case_sensitive",
  view = {
    width = 40,
  },
  renderer = {
    root_folder_label = false,
    group_empty = true,
    icons = {
      webdev_colors = true,
    },
  },
  hijack_directories = {
    enable = false,
    auto_open = true,
  },
  filters = {
    dotfiles = false, -- Display dotfiles
    custom = { "^.git$" }, -- list of filenames to hide
    exclude = {}, -- list of patterns to exclude
  },
  git = {
    ignore = false -- makes git ignored files invisible
  },
  actions = {
    open_file = {
      quit_on_open = false
    }
  }
})

-- Keymaps
vim.keymap.set('n', 'tt', ':NvimTreeToggle<CR>', { silent = true })
vim.keymap.set('n', 'tf', ':NvimTreeFindFile<CR>', { silent = true })
vim.keymap.set('n', 'tc', ':NvimTreeCollapse<CR>', { silent = true })

