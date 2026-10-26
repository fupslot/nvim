local status, saga = pcall(require, "lspsaga")
if not status then
	return
end

saga.setup({
	ui = {
		border = "rounded",
	},
	lightbulb = {
		enable = false,
	},
	symbol_in_winbar = {
		enable = false,
	},
})
