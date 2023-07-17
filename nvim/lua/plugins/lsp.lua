local specs = {}

local u = require("utils")

local cfgs = {}
local servers = { "bashls" }

local group = vim.api.nvim_create_augroup(u.username .. ".lsp", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
  group = group,
  callback = function(args)
    local noformat = u.contains(args.buf, "noformat", 3)
    if noformat then
      return
    end
    local client = vim.lsp.get_active_clients()[1]
    if client and client.server_capabilities.documentFormattingProvider then
      vim.lsp.buf.format({ async = false })
      return
    else
    end
  end,
})

cfgs.gopls = {
  settings = {
    gopls = {
      analyses = {
        fieldalignment = true,
        nilness = true,
        shadow = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
        unusedvariable = true,
      },
      staticcheck = true,
      gofumpt = true,
    },
  },
}

cfgs.lua_ls = {
  settings = {
    Lua = {
      workspace = {
        checkThirdParty = false,
      },
      telemetry = {
        enable = false,
      },
    },
  },
}

local zero_preset = {
  float_border = "rounded",
  call_servers = "global",
  configure_diagnostics = true,
  setup_servers_on_start = true,
  set_lsp_keymaps = {
    preserve_mappings = false,
    omit = {},
  },
  manage_nvim_cmp = {
    set_sources = "recommended",
    set_basic_mappings = true,
    set_extra_mappings = true,
    use_luasnip = true,
    set_format = true,
    documentation_window = true,
  },
}


specs.lspzero = {
  "VonHeikemen/lsp-zero.nvim",
  event = { "VeryLazy", "BufReadPost", "BufNewFile" },
  dependencies = {
    "neovim/nvim-lspconfig",
    { "folke/neodev.nvim", opts = {} },
    "j-hui/fidget.nvim",
    "L3MON4D3/LuaSnip",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-path",
    { "hrsh7th/nvim-cmp",  version = false }, -- override default verions
    "saadparwaiz1/cmp_luasnip",
  },
  branch = "v2.x",
  opts = {},
  config = function()
    local lsp = require("lsp-zero").preset(zero_preset)
    lsp.on_attach(function(_, bufnr)
      lsp.default_keymaps({ buffer = bufnr })
    end)
    local lspconfig = require("lspconfig")
    lspconfig.gopls.setup(cfgs.gopls)
    lspconfig.lua_ls.setup(lsp.nvim_lua_ls(cfgs.lua_ls))
    lsp.setup_servers(servers)

    lsp.skip_server_setup({ 'hls' })
    lsp.setup()
  end,
}

specs.frsnips = {
  "rafamadriz/friendly-snippets",
  config = function()
    require("luasnip.loaders.from_vscode").lazy_load()
  end,
}

specs.luasnip = {
  "L3MON4D3/LuaSnip",
  dependencies = "rafamadriz/friendly-snippets",
  -- if build fails, install jsregexp luarock
  build = "echo 'NOTE: jsregexp is optional, so not a big deal if it fails to build'; make install_jsregexp",
}


return u.respec(specs)
