-- The wildcard config preserves per-server capabilities, including Rust's extensions.
vim.lsp.config("*", {
  capabilities = vim.tbl_deep_extend(
    "force",
    vim.lsp.protocol.make_client_capabilities(),
    require("cmp_nvim_lsp").default_capabilities()
  ),
})

-- nvim-lspconfig ships the server defaults (cmd, filetypes, root markers) in its
-- lsp/ directory, which nvim picks up off the runtimepath; vim.lsp.config only
-- layers our overrides on top of those.
vim.lsp.config("lua_ls", {
  settings = {
    Lua = {
      runtime = {
        version = "LuaJIT",
      },
      workspace = {
        checkThirdParty = false,
        library = {
          vim.env.VIMRUNTIME,
        },
      },
    },
  },
})

vim.lsp.config("bashls", {
  settings = {
    bashIde = {
      -- nvim-lint owns ShellCheck diagnostics, including without an LSP client.
      shellcheckPath = "",
    },
  },
})

-- Neovim supplies rust-analyzer, but the project shell supplies the toolchain
-- so Cargo, rustc, Clippy, and rust-src match the project rather than a global version.
local rust_root_dir = vim.lsp.config.rust_analyzer.root_dir
local has_clippy = vim.fn.executable("cargo-clippy") == 1
  and vim.fn.executable("clippy-driver") == 1

vim.lsp.config("rust_analyzer", {
  root_dir = function(bufnr, on_dir)
    local missing = {}
    for _, tool in ipairs({ "cargo", "rustc" }) do
      if vim.fn.executable(tool) == 0 then
        table.insert(missing, tool)
      end
    end
    if #missing > 0 then
      -- The upstream root resolver invokes both rustc and cargo before starting the server.
      vim.notify_once(
        "Rust LSP disabled: missing "
          .. table.concat(missing, ", ")
          .. ". Restart Neovim from the project's development shell.",
        vim.log.levels.WARN
      )
      return
    end
    if not has_clippy then
      vim.notify_once(
        "Rust LSP: Clippy is unavailable; using cargo check. For Clippy diagnostics, provide cargo-clippy and clippy-driver in the project shell and restart Neovim.",
        vim.log.levels.WARN
      )
    end

    -- Preserve upstream Cargo workspace discovery rather than using Neovim's cwd.
    rust_root_dir(bufnr, on_dir)
  end,
  settings = {
    ["rust-analyzer"] = {
      checkOnSave = true,
      check = { command = has_clippy and "clippy" or "check" },
    },
  },
})

vim.lsp.enable({
  "bashls",
  "pyright",
  "dockerls",
  "lua_ls",
  "marksman",
  "nil_ls",
  "rust_analyzer",
  "sqls",
  "taplo",
  "terraformls",
  "yamlls",
})

-- Underline the other uses of whatever the cursor is resting on, and drop them
-- again as soon as it moves. Gated on the capability so buffers whose server
-- cannot answer do not carry the autocmds.
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if
      not client or not client:supports_method("textDocument/documentHighlight")
    then
      return
    end

    local group = vim.api.nvim_create_augroup(
      "lsp_document_highlight_" .. args.buf,
      { clear = true }
    )

    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = group,
      buffer = args.buf,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      group = group,
      buffer = args.buf,
      callback = vim.lsp.buf.clear_references,
    })
  end,
})
