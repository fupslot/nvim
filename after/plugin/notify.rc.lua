local status, notify = pcall(require, "notify")
if (not status) then return end

notify.setup {
  render = 'simple',
  stages = 'fade',
  timeout = 100
}

vim.notify = notify
