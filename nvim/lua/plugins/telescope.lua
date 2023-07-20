local specs = {}

local u = require("utils")

local keys = {}

local builtin = require("telescope.builtin")
keys.telescope = {
  { "<Leader>fp", builtin.builtin,                       desc = "Telescope: Builtin" },
  { "<Leader>fo", builtin.find_files,                    desc = "Telescope: Find Files" },
  { "<Leader>fb", builtin.buffers,                       desc = "Telescope: Buffers" },
  { "<Leader>fg", builtin.live_grep,                     desc = "Telescope: Live Grep" },
  { "<Leader>fs", builtin.lsp_document_symbols,          desc = "Telescope: LSP Document Symbols" },
  { "<Leader>fS", builtin.lsp_dynamic_workspace_symbols, desc = "Telescope: LSP Dynamic Workspace Symbols" },
}

specs.telescope = {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.2",
  dependencies = { "nvim-lua/plenary.nvim" },
  keys = keys.telescope,
  config = function()
    local telescope = require("telescope")
    telescope.setup({
      pickers = {
        find_files = { hidden = true, file_ignore_patterns = { "%.[^/]+/" } },
      },
      extensions = {
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
        zoxide = { prompt_title = "Zoxide" },
      },
    })
    require("telescope").load_extension("fzf")
  end,
}

specs.fzf = {
  "nvim-telescope/telescope-fzf-native.nvim",
  build = "make",
}

specs.zoxide = {
  "jvgrootveld/telescope-zoxide",
  keys = {
    {
      "<Leader>fj",
      function() require("telescope").extensions.zoxide.list() end,
      desc = "Zoxide: Jump"
    }
  },
  config = function()
    require("telescope").load_extension("zoxide")
  end
}

return u.respec(specs)
