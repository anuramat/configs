local specs = {}
local u = require('utils')

specs.lualine = {
  'nvim-lualine/lualine.nvim',
  event = 'VeryLazy',
  dependencies = {
    'arkav/lualine-lsp-progress',
    'Mofiqul/dracula.nvim',
    'ThePrimeagen/harpoon',
  },
  opts = function()
    return {
      options = {
        theme = 'dracula-nvim',
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
        globalstatus = true,
        refresh = { statusline = 100 },
      },
      extensions = { 'fugitive', 'lazy', 'quickfix', 'trouble', 'man', 'nvim-dap-ui' },
      tabline = {
        lualine_a = {
          {
            'buffers',
            mode = 4,
            hide_filename_extension = false,
            show_filename_only = false,
          },
        },
        lualine_z = { { tabline, padding = 0 } }, -- luacheck: ignore tabline
      },
      sections = {
        lualine_a = {
          {
            'location',
            padding = { left = 1, right = 0 },
            fmt = function(s)
              local result = string.format('%-6s', u.trim(s))
              if result[#result] ~= ' ' then
                result = result .. ' '
              end
              return result
            end,
          },
          {
            'progress',
            padding = { left = 0, right = 1 },
          },
        },
        lualine_b = {
          {
            function()
              return vim.fn.getcwd()
            end,
          },
          { 'branch', icon = '󰊢', align = 'right' },
        },
        lualine_c = {
          { 'filename', path = 1, symbols = { modified = '  ', readonly = '  ', unnamed = '' } },
        },
        lualine_x = {
          {
            'lsp_progress',
            -- With spinner
            display_components = { 'lsp_client_name', 'spinner' },
            timer = { spinner = 100 }, -- limited by statusline refresh rate
            spinner_symbols = { '🌑 ', '🌒 ', '🌓 ', '🌔 ', '🌕 ', '🌖 ', '🌗 ', '🌘 ' },
          },
        },
        lualine_y = {
          { 'diagnostics', symbols = { error = ' ', warn = ' ', info = ' ', hint = ' ' } },
          {
            function()
              return '  ' .. require('dap').status()
            end,
            cond = function()
              return package.loaded['dap'] and require('dap').status() ~= ''
            end,
          },
        },
        lualine_z = {
          {
            'tabs',
            mode = 2,
          },
        },
      },
    }
  end,
}

return u.values(specs)
