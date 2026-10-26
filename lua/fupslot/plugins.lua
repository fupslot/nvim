-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- Colorscheme (load first so other UI plugins can theme themselves)
	{ "ellisonleao/gruvbox.nvim", priority = 1000 },

	-- Common utilities
	"nvim-lua/plenary.nvim",

	-- UI
	"nvim-lualine/lualine.nvim",
	"nvim-tree/nvim-web-devicons",
	"rcarriga/nvim-notify",
	"onsails/lspkind.nvim",

	-- Completion
	"hrsh7th/nvim-cmp",
	"hrsh7th/cmp-buffer",
	"hrsh7th/cmp-nvim-lsp",
	"hrsh7th/cmp-path",
	"saadparwaiz1/cmp_luasnip",
	{ "L3MON4D3/LuaSnip", tag = "v2.3.0", build = "make install_jsregexp" },
	"rafamadriz/friendly-snippets",

	-- LSP
	"williamboman/mason.nvim",
	"williamboman/mason-lspconfig.nvim",
	"neovim/nvim-lspconfig",
	"nvimdev/lspsaga.nvim",
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},

	-- Formatter
	"stevearc/conform.nvim",

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "master",
		build = ":TSUpdate",
	},

	-- Telescope
	"nvim-telescope/telescope.nvim",
	"nvim-telescope/telescope-ui-select.nvim",

	-- File tree
	"nvim-tree/nvim-tree.lua",

	-- Buffers
	{
		"akinsho/bufferline.nvim",
		version = "*",
		dependencies = { "nvim-tree/nvim-web-devicons" },
	},
	"moll/vim-bbye",

	-- Editing helpers
	"windwp/nvim-autopairs",
	"windwp/nvim-ts-autotag",
	{
		"numToStr/Comment.nvim",
		dependencies = { "JoosepAlviste/nvim-ts-context-commentstring" },
	},

	-- Tmux
	"christoomey/vim-tmux-navigator",

	-- Git
	"airblade/vim-gitgutter",

	-- Copilot
	"github/copilot.vim",
})
