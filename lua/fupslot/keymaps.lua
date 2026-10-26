local fileinfo = require("fupslot.fileinfo")

vim.keymap.set("n", "x", '"_x')

-- Delete a word backwards
vim.keymap.set("n", "dw", 'vb"_d')
vim.keymap.set("n", "ds", 'b"_de')

-- Clear highlights
vim.keymap.set("n", "nh", ":nohl<CR>")

-- Select all
vim.keymap.set("n", "<C-a>", "gg<S-v>G")

-- Normal mode
vim.keymap.set("i", "jk", "<ESC>")

-- New tab
vim.keymap.set("n", "te", ":tabedit")

-- Split window
vim.keymap.set("n", "ss", ":split<CR>")
vim.keymap.set("n", "sv", ":vsplit<CR>")

-- Resize window
vim.keymap.set("n", "<C-w><left>", "<C-w><")
vim.keymap.set("n", "<C-w><right>", "<C-w>>")
vim.keymap.set("n", "<C-w><up>", "<C-w>+")
vim.keymap.set("n", "<C-w><down>", "<C-w>-")

-- File info popup
vim.keymap.set('n', '<leader>i', fileinfo.show, { desc = 'Show file info' })

-- Save
vim.keymap.set("n", "<Leader>w", ":w<CR>")
vim.keymap.set("n", "<Leader>W", ":wq<CR>")

-- Copilot
vim.g.copilot_no_tab_map = true
vim.keymap.set('i', '<C-J>', 'copilot#Accept("\\<CR>")', {
  expr = true,
  replace_keycodes = false
}) -- accept the current suggestion
vim.keymap.set('i', '<C-L>', '<Plug>(copilot-accept-word)') -- accept word with Copilot

-- Close vim
vim.keymap.set("n", "<Leader>Q", function()
	local bufs = vim.fn.getbufinfo({ bufloaded = 1, buflisted = 1 })
	local has_unsaved_changes = false

	for _, buf in pairs(bufs) do
		if buf.changed == 1 then
			has_unsaved_changes = true
			break
		end
	end

	if has_unsaved_changes then
		if vim.fn.confirm("Quit without saving?", "&Yes\n&No") == 1 then
			vim.cmd(":quitall!")
		end
	else
		vim.cmd(":quitall!")
	end
end)
-- keymap.set('n', '<C-q>', ':quitall!<CR>')

