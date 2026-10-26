local status, ts = pcall(require, "nvim-treesitter.configs")
if (not status) then return end

ts.setup {
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },

  indent = {
    -- Tree-sitter indentation. Python's TS indent is unreliable, so leave that
    -- filetype to Neovim's built-in smartindent/autoindent.
    enable = true,
    disable = { "python" },
  },

  incremental_selection = {
    enable = true,
    keymaps = {
      init_selection = "<C-space>",
      node_incremental = "<C-space>",
      node_decremental = "<bs>",
      scope_incremental = false,
    },
  },

  sync_install = false,
  auto_install = false,

  ensure_installed = {
    "markdown",
    "markdown_inline",
    "dockerfile",
    "bash",
    "toml",
    "ini",
    "json",
    "yaml",
    "css",
    "html",
    "go",
    "hcl",
    "python",
    "typescript",
    "javascript",
    "lua",
    "terraform",
    "vimdoc"
  }
}
