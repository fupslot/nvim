local M = {}

-- Format a byte count as a human-readable string (1.6 KB, 2.3 MB, ...).
local function human_size(bytes)
	local units = { "B", "KB", "MB", "GB", "TB" }
	local size = bytes
	local i = 1
	while size >= 1024 and i < #units do
		size = size / 1024
		i = i + 1
	end
	if i == 1 then
		return string.format("%d %s", size, units[i])
	end
	return string.format("%.1f %s", size, units[i])
end

-- Show a centered, read-only float with basic attributes of the current file.
-- Strict: only opens for a buffer backed by a file that exists on disk; any
-- other buffer (unnamed, never-saved, terminal, NvimTree, ...) just notifies.
-- Size / Modified come from fs_stat, i.e. the on-disk (saved) version, even if
-- the buffer has unsaved changes. Press `y` (or <CR>) on a line to copy just
-- that attribute's value to the clipboard; `q`/`<Esc>` dismiss.
function M.show()
	local buf = vim.api.nvim_get_current_buf()
	local path = vim.api.nvim_buf_get_name(buf)

	local uv = vim.uv or vim.loop
	local stat = path ~= "" and uv.fs_stat(path) or nil
	if not stat then
		vim.notify("Not a file buffer", vim.log.levels.WARN)
		return
	end

	local ft = vim.bo[buf].filetype
	local attrs = {
		{ "Name", vim.fn.fnamemodify(path, ":t") },
		{ "Size", human_size(stat.size) },
		{ "Absolute path", vim.fn.fnamemodify(path, ":p") },
		{ "Relative path", vim.fn.fnamemodify(path, ":~:.") },
		{ "Filetype", ft ~= "" and ft or "—" },
		{ "Modified", os.date("%Y-%m-%d %H:%M", stat.mtime.sec) },
		{ "Lines", tostring(vim.api.nvim_buf_line_count(buf)) },
	}

	-- Pad labels so the values line up in a column.
	local label_width = 0
	for _, a in ipairs(attrs) do
		label_width = math.max(label_width, #a[1])
	end

	local lines = {}
	local values = {}
	for i, a in ipairs(attrs) do
		-- Leading space keeps text off the border.
		lines[i] = string.format(" %-" .. label_width .. "s  %s", a[1], a[2])
		values[i] = a[2]
	end

	-- Fit the window to the content, clamping width to the editor.
	local width = 0
	for _, line in ipairs(lines) do
		width = math.max(width, vim.fn.strdisplaywidth(line))
	end
	width = math.min(width, vim.o.columns - 4)
	local height = #lines

	-- Scratch buffer holding the card; wiped when the window closes.
	local info_buf = vim.api.nvim_create_buf(false, true)
	vim.api.nvim_buf_set_lines(info_buf, 0, -1, false, lines)
	vim.bo[info_buf].modifiable = false
	vim.bo[info_buf].bufhidden = "wipe"

	local win = vim.api.nvim_open_win(info_buf, true, {
		relative = "editor",
		row = math.max(0, math.floor((vim.o.lines - height) / 2) - 1),
		col = math.max(0, math.floor((vim.o.columns - width) / 2)),
		width = width,
		height = height,
		style = "minimal",
		border = "rounded",
		title = " File info ",
		title_pos = "center",
		footer = " y copy value · q close ",
		footer_pos = "center",
	})
	vim.wo[win].wrap = false

	-- Dismiss with q or <Esc>; closing returns focus to the previous window.
	local function close()
		if vim.api.nvim_win_is_valid(win) then
			vim.api.nvim_win_close(win, true)
		end
	end
	for _, key in ipairs({ "q", "<Esc>" }) do
		vim.keymap.set("n", key, close, { buffer = info_buf, nowait = true, silent = true })
	end

	-- Copy just the value (not the label) of the line under the cursor.
	local function copy_value()
		local lnum = vim.api.nvim_win_get_cursor(win)[1]
		local value = values[lnum]
		if value and value ~= "" then
			vim.fn.setreg("+", value)
			vim.fn.setreg('"', value)
			vim.notify("Copied: " .. value)
		end
	end
	for _, key in ipairs({ "y", "Y", "<CR>" }) do
		vim.keymap.set("n", key, copy_value, { buffer = info_buf, nowait = true, silent = true })
	end

	-- Also close if focus leaves the popup.
	vim.api.nvim_create_autocmd("BufLeave", { buffer = info_buf, once = true, callback = close })
end

return M
