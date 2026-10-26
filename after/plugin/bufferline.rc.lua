local status, bufferline = pcall(require, "bufferline")
if (not status) then return end

local opts = {
  options = {
    numbers = "none",
    close_command = "Bdelete! %d",
    diagnostics = "nvim_lsp",
    diagnostics_indicator = function(count, level, diagnostics_dict, context)
      local icon = level:match("error") and " " or " "
      return " " .. icon .. count
    end,
    indicator = {
      style = "none",
    },
    offsets = {
      {
        filetype = "NvimTree",
        text = "File Explorer",
        highlight = "Directory",
        text_align = "left"
      }
    },
    tab_size = 25,
    max_name_length = 20,
    max_prefix_length = 20,
    separator_style = "thin"
  }
}

-- Defer setup by one event-loop tick so that all ColorScheme handlers have
-- finished. Bufferline derives its highlights (BufferLineBufferSelected,
-- BufferLineFill, etc.) from source groups like Normal and TabLine; running
-- setup synchronously here races the colorscheme and produces highlights with
-- no guifg/guibg. See `:hi BufferLineBufferSelected` before vs after `,vs`.
vim.schedule(function()
  bufferline.setup(opts)
end)

vim.keymap.set('n', 'L', ':BufferLineCycleNext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', 'H', ':BufferLineCyclePrev<CR>', { noremap = true, silent = true })
