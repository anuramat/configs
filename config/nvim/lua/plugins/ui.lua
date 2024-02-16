local specs = {}
local u = require('utils')

specs.dracula_cs = {
  'Mofiqul/dracula.nvim',
  priority = 1337,
  lazy = false,
  config = function()
    local dracula = require('dracula')
    local cs = dracula.colors()
    local opts = {
      italic_comment = true,
      lualine_bg_color = cs.bg,
      transparent_bg = false,
    }
    dracula.setup(opts)

    vim.cmd.colorscheme('dracula')

    -- Override shitty default CodeLens style
    local clhl = vim.api.nvim_get_hl(0, { name = 'LspCodeLens' })
    clhl.standout = true
    vim.api.nvim_set_hl(0, 'LspCodeLens', clhl)

    -- TODO what the fuck does this do
    vim.cmd('highlight! link FloatBorder Normal')
    vim.cmd('highlight! link NormalFloat Normal')

    -- Make window borders properly visible
    vim.cmd('hi WinSeparator guibg=bg guifg=fg')

    -- Make Telescope have proper background
    vim.api.nvim_set_hl(0, 'TelescopeNormal', { bg = 'none' })
  end,
}

specs.indentline = {
  'lukas-reineke/indent-blankline.nvim',
  event = 'VeryLazy',
  main = 'ibl',
  opts = {
    exclude = {
      filetypes = {
        'lazy',
      },
    },
    indent = { char = '│' },
    scope = {
      enabled = true,
      show_start = false,
      show_end = false,
    },
  },
}

specs.zen = {
  'folke/zen-mode.nvim',
  cmd = 'ZenMode',
  opts = {
    window = {
      backdrop = 1,
      width = 1,
      height = 1,
      options = {},
    },
    plugins = {
      options = {
        enabled = true,
        ruler = false,
        showcmd = false,
      },
      gitsigns = { enabled = true }, -- hide gitsigns
      tmux = { enabled = true }, -- hide tmux bar BUG can hide bar until tmux restart, careful
    },
  },
}

specs.fidget = {
  'j-hui/fidget.nvim',
  tag = 'legacy',
  event = 'LspAttach',
  opts = {},
}

specs.noice = {
  'folke/noice.nvim',
  dependencies = {
    'MunifTanjim/nui.nvim',
    'rcarriga/nvim-notify',
    {
      'smjonas/inc-rename.nvim',
      config = function()
        require('inc_rename').setup()
      end,
    },
  },
  event = 'VeryLazy',
  opts = {
    presets = {
      lsp_doc_border = true,

      bottom_search = true, -- use a classic bottom cmdline for search
      command_palette = true, -- position the cmdline and popupmenu together
      long_message_to_split = true, -- long messages will be sent to a split
      inc_rename = true, -- enables an input dialog for inc-rename.nvim
    },
    lsp = {
      override = {
        -- TODO what is this even
        ['vim.lsp.util.convert_input_to_markdown_lines'] = true,
        ['vim.lsp.util.stylize_markdown'] = true,
        ['cmp.entry.get_documentation'] = true, -- requires hrsh7th/nvim-cmp
      },
    },
  },
}

specs.dressing = {
  'stevearc/dressing.nvim',
  opts = {
    input = {
      enabled = false,
    },
  },
  lazy = false,
}

return u.values(specs)
