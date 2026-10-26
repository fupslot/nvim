-- Uses the Neovim 0.11+ LSP API. nvim-lspconfig ships default configs in
-- lsp/<server>.lua; vim.lsp.config() extends them, vim.lsp.enable() turns
-- them on. See :help lspconfig-nvim-0.11.

local cmp_lsp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
local capabilities = cmp_lsp_ok
  and cmp_nvim_lsp.default_capabilities()
  or vim.lsp.protocol.make_client_capabilities()

-- Force every server to use UTF-16 so we don't get "buffers attached to
-- multiple clients with different position encodings" warnings.
capabilities.general = capabilities.general or {}
capabilities.general.positionEncodings = { "utf-16" }

-- Apply capabilities to every server.
vim.lsp.config("*", { capabilities = capabilities })

-- lua_ls: recognize `vim` as a global so it stops emitting undefined-global warnings.
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      diagnostics = { globals = { "vim" } },
      hint = { enable = true }, -- inlay hints
    },
  },
})

-- pyright: navigate into installed package source, not just .pyi stubs.
-- Requires Pyright to see the project's venv — set VIRTUAL_ENV before launching
-- nvim, or commit a pyrightconfig.json / [tool.pyright] with venvPath + venv.
vim.lsp.config("pyright", {
  settings = {
    python = {
      analysis = {
        autoSearchPaths = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = "openFilesOnly",
        inlayHints = {
          variableTypes = true,
          functionReturnTypes = true,
          callArgumentNames = true,
        },
      },
    },
  },
})

-- ruff: linting and import sorting only; let pyright own hover/definitions
-- so `gd` resolves into package source instead of stopping at ruff.
vim.lsp.config("ruff", {
  on_attach = function(client, _)
    client.server_capabilities.hoverProvider = false
    client.server_capabilities.definitionProvider = false
  end,
})

-- ts_ls: inlay hints are disabled. TypeScript's inlay-hints provider crashes
-- ("Debug Failure. Unexpected node. Node IndexSignature was unexpected.") on
-- TS 5.3.3 when a hint renders an inferred type containing an index signature.
-- Dropping the inlayHintProvider capability stops nvim from requesting hints,
-- so the generic LspAttach handler (lua/fupslot/lsp.lua) skips ts_ls. Re-enable
-- once projects move to a fixed TypeScript (5.4+).
vim.lsp.config("ts_ls", {
  on_attach = function(client, _)
    client.server_capabilities.inlayHintProvider = nil
  end,
})

-- Enable every server Mason installs (see mason.rc.lua).
vim.lsp.enable({
  "html",
  "lua_ls",
  "jsonls",
  "ts_ls",
  "tailwindcss",
  "terraformls",
  "pyright",
  "ruff",
})
