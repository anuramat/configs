-- vim: fdl=2

local ul = require('utils.lsp')

--- Root directory function with a fallback
--- @param opts { primary: string[], fallback: string[] }
local root_dir_with_fallback = function(opts)
  local util = require('lspconfig.util')
  return function(fname)
    local primary_root = util.root_pattern(unpack(opts.primary))(fname)
    local fallback_root = util.root_pattern(unpack(opts.fallback))(fname)
    return primary_root or fallback_root
  end
end

-- <https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md>
--- Returns configs for specific lsps
--- @return table configs
local configs = function()
  return {
    -- supports options, packages
    nixd = {
      cmd = { 'nixd', '--inlay-hints=false' },
      settings = {
        nixd = {
          -- this can fail silently
          -- apparently this breaks shit while editing
          -- options = {
          --   -- keys don't matter
          --   nixos = {
          --     expr = string.format(
          --       '(builtins.getFlake "/etc/nixos/").nixosConfigurations.%s.options',
          --       vim.fn.hostname()
          --     ),
          --   },
          -- },
          diagnostic = {
            suppress = {},
          },
        },
      },
    },
    -- nil_ls = {}, -- nice code actions
    yamlls = {
      -- we can use schemastore plugin if we need more logic
      -- eg replacements or custom schemas
    },
    jsonls = {
      cmd = { 'vscode-json-languageserver', '--stdio' },
      schemas = require('schemastore').json.schemas(),
    },
    texlab = {},
    bashls = {
      settings = {
        bashIde = {
          shfmt = {
            binaryNextLine = true,
            caseIndent = true,
            simplifyCode = true,
            spaceRedirects = true,
          },
        },
      },
    },
    pyright = {
      settings = {
        python = {},
      },
    },
    marksman = {},
    clangd = {
      on_attach = function(client, buffer)
        vim.api.nvim_buf_set_keymap(
          buffer,
          'n',
          '<localleader>6',
          '<cmd>ClangdSwitchSourceHeader<cr>',
          { silent = true, desc = 'clangd: Switch between .c/.h' }
        )
        ul.on_attach(client, buffer)
        require('clangd_extensions.inlay_hints').setup_autocmd()
        require('clangd_extensions.inlay_hints').set_inlay_hints()
      end,
      filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' }, -- 'proto' removed
    },
    gopls = {
      settings = {
        gopls = {
          analyses = {
            fieldalignment = true,
            shadow = true,
            unusedwrite = true,
            useany = true,
            unusedvariable = true,
          },
          codelenses = {
            gc_details = true,
            generate = true,
            regenerate_cgo = true,
            tidy = true,
            upgrade_dependency = true,
            vendor = true,
          },
          hints = {
            assignVariableTypes = false,
            compositeLiteralFields = true,
            compositeLiteralTypes = true,
            constantValues = true,
            functionTypeParameters = true,
            parameterNames = false,
            rangeVariableTypes = true,
          },
          usePlaceholders = true,
          staticcheck = true,
          gofumpt = true,
          semanticTokens = true,
        },
      },
      root_dir = root_dir_with_fallback({
        primary = { '.git' },
        fallback = { 'go.work', 'go.mod' },
      }),
    },
    lua_ls = {
      settings = {
        Lua = {
          runtime = {
            version = 'LuaJIT',
          },
          format = {
            enable = false, -- using stylua instead
          },
          telemetry = {
            enable = false,
          },
        },
      },
    },
  }
end

return {
  'neovim/nvim-lspconfig',
  event = { 'BufReadPre', 'BufNewFile' },
  dependencies = {
    'saghen/blink.cmp',
    'b0o/schemastore.nvim', -- yamlls, jsonls dependency
  },
  config = function()
    ul.apply_settings()
    local lspconfig = require('lspconfig')
    for name, cfg in pairs(configs()) do
      cfg.capabilities = ul.capabilities()
      if cfg.on_attach == nil then
        cfg.on_attach = ul.on_attach
      end
      lspconfig[name].setup(cfg)
    end
  end,
}
