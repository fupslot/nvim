local status, conform = pcall(require, "conform")
if not status then
	return
end

conform.setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff_format", "ruff_fix" },
		javascript = { "prettierd", "prettier", stop_after_first = true },
		typescript = { "prettierd", "prettier", stop_after_first = true },
		javascriptreact = { "prettierd", "prettier", stop_after_first = true },
		typescriptreact = { "prettierd", "prettier", stop_after_first = true },
		yaml = { "yamlfmt" },
		json = { "prettierd", "prettier", stop_after_first = true },
	},
	formatters = {
		yamlfmt = {
			-- Keep blank lines between blocks (collapses runs of several into one).
			prepend_args = { "-formatter", "retain_line_breaks_single=true" },
		},
	},
	format_on_save = function(bufnr)
		-- Respect a per-buffer / global opt-out (toggle with <leader>tf or :FormatToggle).
		if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
			return
		end
		return { timeout_ms = 2000, lsp_fallback = true }
	end,
})

-- Manual format, always available regardless of the auto-format toggle.
vim.keymap.set("n", "<leader>f", function()
	conform.format({
		async = false,
		lsp_fallback = true,
		timeout_ms = 2000,
	})
end, { desc = "Format buffer" })

-- Toggle format-on-save. `:FormatToggle` flips it globally; `:FormatToggle!`
-- flips it for the current buffer only.
vim.api.nvim_create_user_command("FormatToggle", function(cmd)
	if cmd.bang then
		vim.b.disable_autoformat = not vim.b.disable_autoformat
	else
		vim.g.disable_autoformat = not vim.g.disable_autoformat
	end
	local disabled = cmd.bang and vim.b.disable_autoformat or vim.g.disable_autoformat
	vim.notify(string.format("Format on save (%s): %s", cmd.bang and "buffer" or "global", disabled and "OFF" or "ON"))
end, { bang = true, desc = "Toggle format on save" })

vim.keymap.set("n", "<leader>tf", "<Cmd>FormatToggle<CR>", { desc = "Toggle format on save (global)" })
