local specs = {}

local u = require("utils")

local langs = {
  "go", "gosum", "gomod", "gowork", "python", "haskell", "bash", "c", "json",
  "lua", "luadoc", "luap", "markdown", "markdown_inline", "python", "query",
  "regex", "vim", "vimdoc", "yaml", "sql"
}

specs.treesitter = {
  "nvim-treesitter/nvim-treesitter",
  version = false, -- last release is way too old
  build = ":TSUpdate",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter-textobjects",
    'JoosepAlviste/nvim-ts-context-commentstring',
  },
  cmd = { "TSUpdateSync" },
  opts = {
    highlight = { enable = true },
    indent = { enable = true },
    ensure_installed = langs,
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<c-space>",
        node_incremental = "<c-space>",
        scope_incremental = "<c-s>",
        node_decremental = "<bs>",
      },
    },
    textobjects = {
      swap = {
        enable = true,
        swap_next = { ["<a-h>"] = "@parameter.inner" },
        swap_previous = { ["<a-l>"] = "@parameter.inner" },
      },
    },
    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },
  },
  config = function(_, opts) require("nvim-treesitter.configs").setup(opts) end,
}

return u.respec(specs)
