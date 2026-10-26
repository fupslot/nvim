local groups = require ("fupslot.autogroups")
local ts_builtin = require("telescope.builtin")

-- Buffer-local autocmds for LSP document highlighting live in this group so we
-- can clear and re-add them cleanly each time a client attaches.
local doc_highlight_group = vim.api.nvim_create_augroup("Fupslot_LspDocumentHighlight", { clear = false })

vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup(groups.LspAttachMappings, { clear = true }),
	callback = function(args)
		local client_id = args.data.client_id
		local client = vim.lsp.get_client_by_id(client_id)

		-- Inlay hints: show inferred types / parameter names inline.
		if client and client:supports_method("textDocument/inlayHint") then
			vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
		end

		-- Document highlight: highlight other uses of the symbol under the cursor.
		if client and client:supports_method("textDocument/documentHighlight") then
			vim.api.nvim_clear_autocmds({ group = doc_highlight_group, buffer = args.buf })
			vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
				group = doc_highlight_group,
				buffer = args.buf,
				callback = vim.lsp.buf.document_highlight,
			})
			vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
				group = doc_highlight_group,
				buffer = args.buf,
				callback = vim.lsp.buf.clear_references,
			})
		end

		-- Hover documentation
		vim.keymap.set("n", "K", function()
			vim.lsp.buf.hover({ border = "rounded" })
		end, { buffer = args.buf, remap = false })

		-- Code action (lspsaga floating UI)
		vim.keymap.set({ "n", "x" }, "<leader>ca", "<Cmd>Lspsaga code_action<CR>", { buffer = args.buf, desc = "Code action" })

		-- Toggle inlay hints in the current buffer
		vim.keymap.set("n", "<leader>th", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf }), { bufnr = args.buf })
		end, { buffer = args.buf, desc = "Toggle inlay hints" })

		-- Peek definition

		-- Telescope builtins for convenience
		vim.keymap.set("n", "gI", ts_builtin.lsp_incoming_calls, { buffer = args.buf, desc = "incoming calls" })
		vim.keymap.set("n", "gO", ts_builtin.lsp_outgoing_calls, { buffer = args.buf, desc = "outgoing calls" })
    vim.keymap.set("n", "gd", ts_builtin.lsp_definitions, { buffer = args.buf, desc = "Go to definition" })
    vim.keymap.set("n", "gr", ts_builtin.lsp_references, { buffer = args.buf, desc = "Go to reference" })
    vim.keymap.set("n", "gs", ts_builtin.lsp_document_symbols, { buffer = args.buf, desc = "Find symbol in document" })
    vim.keymap.set("n", "gS", ts_builtin.lsp_dynamic_workspace_symbols, { buffer = args.buf, desc = "Find symbol in workspace" })
		vim.keymap.set("n", "gT", ts_builtin.lsp_type_definitions, {buffer = args.buf, desc = "type definitions" })
		vim.keymap.set("n", "gi", ts_builtin.lsp_implementations, { buffer = args.buf, desc = "implementations" })

		vim.keymap.set("i", "<c-s>", vim.lsp.buf.signature_help, { buffer = args.buf, desc = "signature help" })

		vim.keymap.set("n", "cd", "<Cmd>Lspsaga rename<CR>", { buffer = args.buf })
		vim.keymap.set("n", "gp", "<Cmd>Lspsaga peek_definition<CR>", { buffer = args.buf })
		vim.keymap.set("n", "<leader>ml", "<Cmd>Lspsaga show_line_diagnostics ++unfocus<CR>", { buffer = args.buf })
		vim.keymap.set("n", "<leader>mL", "<Cmd>Lspsaga show_line_diagnostics<CR>", { buffer = args.buf })
		vim.keymap.set("n", "<leader>mw", "<Cmd>Lspsaga show_workspace_diagnostics ++float<CR>", { buffer = args.buf })
		vim.keymap.set("n", "<leader>mW", "<Cmd>Lspsaga show_workspace_diagnostics<CR>", { buffer = args.buf })

		vim.keymap.set("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { buffer = args.buf, desc = "add folder" })
		vim.keymap.set("n", "<leader>wl", function() print(vim.inspect(vim.lsp.buf.list_workspace_folders())) end, { buffer = args.buf, desc = "list folders" })
		vim.keymap.set("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { buffer = args.buf, desc = "remove folder" })

		-- Disabled native completion in favor of nvim-cmp
		-- if client:supports_method("textDocument/completion") then
		-- 	vim.lsp.completion.enable(true, client_id, args.buf, {
		-- 		autotrigger = true,
		-- 	})
		-- 	vim.bo[args.buf].completeopt = "menuone,popup,fuzzy,noinsert,preview"
		-- end
	end,
})

vim.api.nvim_create_autocmd("LspDetach", {
	group = vim.api.nvim_create_augroup(groups.LspDetachMappings, { clear = true }),
	callback = function(args)
    -- TODO: Removing mappings raises error
	end,
})

vim.diagnostic.config({
	virtual_text = { current_line = true },
	virtual_lines = false,
	jump = { float = true }, -- Show diagnostic in a float window.
	float = { border = "rounded" },
	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = "",
			[vim.diagnostic.severity.WARN] = "",
			[vim.diagnostic.severity.INFO] = "",
			[vim.diagnostic.severity.HINT] = "…",
		},
	},
	underline = { min = vim.diagnostic.severity.ERROR },
})
