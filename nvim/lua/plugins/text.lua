local specs = {}

local u = require("utils")

specs.surround = {
  "kylechui/nvim-surround",
  version = "*", -- use last release instead of main
  event = "VeryLazy",
  opts = {
    keymaps = {
      -- insert = "<C-g>s",
      -- insert_line = "<C-g>S",
      normal = "<Leader>s",
      normal_cur = "<Leader>ss",
      normal_line = "<Leader>S",
      normal_cur_line = "<Leader>SS",
      visual = "<Leader>s",
      visual_line = "<Leader>S",
      -- delete = "ds",
      -- change = "cs",
      -- change_line = "cS",
    }
  },
}

specs.treesj = {
  'Wansmer/treesj',
  event = { "BufReadPost", "BufNewFile" },
  versio = false,
  opts = { use_default_keymaps = false },
  keys = { {
    "<leader>m",
    mode = { "n" },
    function()
      require("treesj").toggle()
    end,
    desc = "TreeSJ: Toggle"
  } }
}



specs.comment = {
  "numToStr/Comment.nvim",
  dependencies = { "nvim-treesitter/nvim-treesitter", "JoosepAlviste/nvim-ts-context-commentstring" },
  event        = "VeryLazy",
  config       = function()
    require("Comment").setup({
      pre_hook = require('ts_context_commentstring.integrations.comment_nvim').create_pre_hook(),
      toggler = {
        line = '<Leader>cc',
        block = '<Leader>cbb',
      },
      opleader = {
        line = '<Leader>c',
        block = '<Leader>cb',
      },
      extra = {
        above = '<Leader>cO',
        below = '<Leader>co',
        eol = '<Leader>cA',
      },
    })
  end,
}

specs.ai = {
  "echasnovski/mini.ai",
  event = "VeryLazy",
  dependencies = { "nvim-treesitter-textobjects" },
  opts = function()
    local ai = require("mini.ai")
    return {
      n_lines = 500,
      custom_textobjects = {
        o = ai.gen_spec.treesitter({
          a = { "@block.outer", "@conditional.outer", "@loop.outer" },
          i = { "@block.inner", "@conditional.inner", "@loop.inner" },
        }, {}),
        f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
        c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
      },
    }
  end,
}

return u.respec(specs)
