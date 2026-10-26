local M = {}

function M.call_and_notify_when_error(fn)
	local ok, err = pcall(fn)
	if not ok then
		vim.notify(err, vim.log.levels.ERROR, { render = "compact" })
	end
end

return M
