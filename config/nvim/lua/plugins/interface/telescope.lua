local u = require('utils')

-- TODO refactor telescope config

return {
  'nvim-telescope/telescope.nvim',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-treesitter/nvim-treesitter',
    'jvgrootveld/telescope-zoxide',
    {
      'nvim-telescope/telescope-fzf-native.nvim',
      build = 'make',
    },
    {
      'nvim-telescope/telescope-live-grep-args.nvim',
      version = '^1.0.0',
    },
  },
  keys = u.lazy_prefix('<leader>f', {
    { 'G', '<cmd>Telescope live_grep_args<cr>', desc = 'Live Grep' },
    { 'S', '<cmd>Telescope lsp_dynamic_workspace_symbols<cr>', desc = 'Dynamic Workspace Symbols' },
    { 'b', '<cmd>Telescope buffers<cr>', desc = 'Buffers' },
    { 'd', '<cmd>Telescope diagnostics<cr>', desc = 'Workspace Diagnostics' },
    { 'g', '<cmd>Telescope live_grep<cr>', desc = 'Live Grep' },
    { 'h', '<cmd>Telescope harpoon marks<cr>', desc = 'Harpoons' },
    { 'j', '<cmd>Telescope zoxide list<cr>', desc = 'Zoxide' },
    { 'm', '<cmd>Telescope marks<cr>', desc = 'Marks' },
    { 'o', '<cmd>Telescope find_files<cr>', desc = 'Files' },
    { 'p', '<cmd>Telescope builtin<cr>', desc = 'Pickers' },
    { 'r', '<cmd>Telescope lsp_references<cr>', desc = 'References' },
    { 's', '<cmd>Telescope lsp_document_symbols<cr>', desc = 'Document Symbols' },
  }, 'Tele'),
  config = function()
    require('telescope').load_extension('zoxide')
    require('telescope').load_extension('fzf')
    require('telescope').load_extension('live_grep_args')
    local telescope = require('telescope')
    local opts = {
      defaults = {
        prompt_prefix = ' ',
        selection_caret = ' ',
        multi_icon = ' ',
        vimgrep_arguments = {
          -- required
          'rg',
          '--color=never',
          '--no-heading',
          '--with-filename',
          '--line-number',
          '--column',
        },
      },
      pickers = {
        keymaps = { show_plug = false },
        colorscheme = { enable_preview = true },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = 'smart_case',
        },
        zoxide = { prompt_title = 'Zoxide' },
      },
    }
    if vim.g.border == 'solid' then
      opts.defaults.borderchars = {
        prompt = { ' ' },
        results = { ' ' },
        preview = { ' ' },
      }
    end
    telescope.setup(opts)
  end,
}
