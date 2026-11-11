-- The wildcard config preserves per-server capabilities, including Rust's extensions.
vim.lsp.config("*", {
  capabilities = vim.tbl_deep_extend(
    "force",
    vim.lsp.protocol.make_client_capabilities(),
    require("cmp_nvim_lsp").default_capabilities()
  ),
})

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
local resolve_rust_root_dir = vim.lsp.config.rust_analyzer.root_dir
local has_clippy = vim.fn.executable("cargo-clippy") == 1
  and vim.fn.executable("clippy-driver") == 1

vim.lsp.config("rust_analyzer", {
  root_dir = function(bufnr, on_dir)
    local missing_tools = {}
    for _, tool in ipairs({ "cargo", "rustc" }) do
      if vim.fn.executable(tool) == 0 then
        table.insert(missing_tools, tool)
      end
    end
    if #missing_tools > 0 then
      -- The upstream root resolver invokes both rustc and cargo before starting the server.
      vim.notify_once(
        "Rust LSP disabled: missing "
          .. table.concat(missing_tools, ", ")
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

    resolve_rust_root_dir(bufnr, on_dir)
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
  "cssls",
  "dockerls",
  "fish_lsp",
  "html",
  "jsonls",
  "just",
  "lua_ls",
  "marksman",
  "nixd",
  "rust_analyzer",
  "sqls",
  "taplo",
  "terraformls",
  "ts_ls",
  "yamlls",
})

local document_highlight_group =
  vim.api.nvim_create_augroup("config.document_highlight", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
  group = document_highlight_group,
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if
      not client
      or not client:supports_method("textDocument/documentHighlight", args.buf)
    then
      return
    end

    vim.api.nvim_clear_autocmds({
      group = document_highlight_group,
      buffer = args.buf,
    })
    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
      group = document_highlight_group,
      buffer = args.buf,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
      group = document_highlight_group,
      buffer = args.buf,
      callback = vim.lsp.buf.clear_references,
    })
  end,
})

vim.api.nvim_create_autocmd("LspDetach", {
  group = document_highlight_group,
  callback = function(args)
    local clients = vim.lsp.get_clients({
      bufnr = args.buf,
      method = "textDocument/documentHighlight",
    })
    for _, client in ipairs(clients) do
      if client.id ~= args.data.client_id then
        return
      end
    end

    vim.api.nvim_buf_call(args.buf, vim.lsp.buf.clear_references)
    vim.api.nvim_clear_autocmds({
      group = document_highlight_group,
      buffer = args.buf,
    })
  end,
})
