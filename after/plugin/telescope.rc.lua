local fn = require("fupslot.functions")
local status, telescope = pcall(require, "telescope")
if not status then
	return
end
local actions = require("telescope.actions")
local builtin = require("telescope.builtin")

-- Scoped to file-search pickers only. Putting these in `defaults` also filters
-- LSP pickers, which silently drops `gd`/`gr` results that land in .venv or
-- node_modules — exactly where you DO want to follow definitions.
local file_ignore = {
	"node_modules/",
	"%.git/",
	"%.cache/",
	"%.DS_Store",
	"%.venv/",
	"__pycache__/",
}

telescope.setup({
	defaults = {
		mappings = {
			n = {
				["q"] = actions.close,
			},
		},
	},
	pickers = {
		find_files = { file_ignore_patterns = file_ignore },
		live_grep = { file_ignore_patterns = file_ignore },
		grep_string = { file_ignore_patterns = file_ignore },
		git_files = { file_ignore_patterns = file_ignore },
	},
	extensions = {
		["ui-select"] = {
			require("telescope.themes").get_dropdown({}),
		},
	},
})

telescope.load_extension("ui-select")

vim.keymap.set("n", "<leader>fg", function()
	builtin.grep_string({
		search = vim.fn.input("Grep > "),
	})
end)

vim.keymap.set("n", "<C-p>", function()
	fn.call_and_notify_when_error(function()
		builtin.git_files()
	end)
end)

vim.keymap.set("n", ";gs", function()
	fn.call_and_notify_when_error(function()
		builtin.git_status()
	end)
end)

vim.keymap.set("n", "'t", function()
	builtin.builtin()
end)

vim.keymap.set("n", "'s", function()
	builtin.treesitter()
end)

vim.keymap.set("n", ";b", function()
	builtin.current_buffer_fuzzy_find()
end)

vim.keymap.set("n", ";f", function()
	builtin.find_files({
		no_ignore = false,
		hidden = true,
	})
end)

vim.keymap.set("n", ";F", function()
	builtin.find_files({
		no_ignore = true,
		hidden = true,
	})
end)

vim.keymap.set("n", ";r", function()
	builtin.live_grep()
end)

vim.keymap.set("n", "\\\\", function()
	builtin.buffers({
		sort_mru = true,
		ignore_current_buffer = true,
	})
end)

vim.keymap.set("n", ";h", function()
	builtin.help_tags()
end)

vim.keymap.set("n", ";;", function()
	builtin.resume()
end)
