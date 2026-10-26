local status, popup = pcall(require, "plenary.popup")
if not status then
	print("plenary.popup is not installed")
	return
end

M = {}

M.select_command = function()
	-- map action key to description
	local actions_display_map = {
		refactor_full = "[ref]: Refactor",
		refactor_selected = "[refsel]: Refactor selected",
	}

	-- get actions keys map
	local actions_keys = vim.tbl_keys(actions_display_map)

	vim.ui.select(actions_keys, {
		prompt = "ChatGPT: How can I help you?",
		format_item = function(item)
			local desc = actions_display_map[item]
			if not desc then
				return "Unknown action: " .. item
			end

			return desc
		end,
	}, function(choice)
		print("Selected: " .. choice)
	end)
end

M.prompt_command = function()
	vim.ui.input({ prompt = "Enter value for shiftwidth: " }, function(input)
		vim.o.shiftwidth = tonumber(input)
	end)
end

local Win_id

M.prompt_popup_show_command = function(opts, cb)
	local height = 1
	local width = 30
	local borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }

  if opts == nil then
    opts = {}
  end

	Win_id = popup.create(opts, {
		title = "MyProjects",
		highlight = "MyProjectWindow",
		line = math.floor(((vim.o.lines - height) / 2) - 1),
		col = math.floor((vim.o.columns - width) / 2),
		minwidth = width,
		minheight = height,
		borderchars = borderchars,
		callback = cb,
	})
	local bufnr = vim.api.nvim_win_get_buf(Win_id)
	-- vim.api.nvim_buf_set_keymap(bufnr, "n", "q", function()
	-- 	vim.api.nvim_win_close(Win_id, true)
	-- end, { silent = false })
end

vim.keymap.set("n", "<leader>ms", function()
	M.select_command()
end, { noremap = true, silent = true })

vim.keymap.set("n", "<leader>mp", function()
	M.prompt_popup_show_command({}, function() print("Callback") end)
end, { noremap = true, silent = true })
