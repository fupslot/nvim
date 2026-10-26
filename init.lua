--- Open the init file. If opened from a project, open in a new tab, and set the
--- working directory for the tab. If opened from within a file in the
--- configuration directory, just open the file normally
local load_init_file = function()
  if vim.fn.getcwd() == vim.fn.stdpath("config") then
    vim.cmd("e $MYVIMRC")
  else
    -- + allows executing an ex-command after opening the tab. `tcd` changes
    -- directory for the tab. %:p:h evaluates to the directory the file exist
    -- in.
    --
    -- - % evaluates to currently open file
    -- - :p expands to the full path of the file
    -- - :h (head) evaluates to the containing directory.
    vim.cmd([[tabnew +tcd\ %:p:h $MYVIMRC]])
  end
end

--- Reload non-plugin config. Skips fupslot.plugins (lazy.nvim refuses to
--- re-run setup) and does not re-source init.lua. Plugin additions/removals
--- still require :Lazy sync + restart.
local function reload()
  local reloadable = { "fupslot.base", "fupslot.keymaps", "fupslot.lsp", "fupslot.theme" }

  for _, name in ipairs(reloadable) do
    package.loaded[name] = nil
  end
  -- Also purge any other fupslot.* utility modules (e.g. functions, autogroups)
  -- but never fupslot.plugins.
  for name, _ in pairs(package.loaded) do
    if name:match("^fupslot") and name ~= "fupslot.plugins" then
      package.loaded[name] = nil
    end
  end

  for _, name in ipairs(reloadable) do
    local ok, err = pcall(require, name)
    if not ok then
      vim.notify("Failed to reload " .. name .. ": " .. err, vim.log.levels.WARN)
    end
  end

  -- Re-source after/plugin/*.lua so plugin config tweaks take effect.
  local after_dir = vim.fn.stdpath("config") .. "/after/plugin"
  for _, f in ipairs(vim.fn.glob(after_dir .. "/*.lua", false, true)) do
    local ok, err = pcall(vim.cmd.luafile, f)
    if not ok then
      vim.notify("Failed to reload " .. f .. ": " .. err, vim.log.levels.WARN)
    end
  end

  print("Reloaded Neovim configuration.")
end

require('fupslot.base')

vim.g.mapleader = ","
vim.g.maplocalleader = ","

vim.keymap.set("n", "<leader>ve", load_init_file, { desc = "Open neovim configuration file" })
vim.keymap.set("n", "<leader>vs", reload, { desc = "Reload Neovim configuration" })


require('fupslot.keymaps')
require('fupslot.plugins')
require('fupslot.lsp')
require('fupslot.theme')
