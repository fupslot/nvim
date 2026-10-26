local mason_setup, mason = pcall(require, "mason")
if not mason_setup then
	return
end

local mason_lspconfig_setup, mason_lspconfig = pcall(require, "mason-lspconfig")
if not mason_lspconfig_setup then
	return
end

mason.setup({
	ui = {
		border = "rounded",
	},
})

mason_lspconfig.setup({
	automatic_installation = false,
	ensure_installed = {
		"html",
		"lua_ls",
		"jsonls",
    "ts_ls",
		"tailwindcss",
		"terraformls",
		"pyright",
		"ruff",
	},
})
