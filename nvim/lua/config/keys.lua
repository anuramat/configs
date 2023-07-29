local M = {}

local function nmap(lhs, rhs, desc)
  vim.keymap.set("n", lhs, rhs, { desc = "Keys: " .. desc, silent = true })
end
local function vmap(lhs, rhs, desc)
  vim.keymap.set("v", lhs, rhs, { desc = "Keys: " .. desc, silent = true })
end
local function imap(lhs, rhs, desc)
  vim.keymap.set("i", lhs, rhs, { desc = "Keys: " .. desc, silent = true })
end

-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Built-in ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
vim.g.mapleader = " "
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true, desc = "Keys: Leader Key" })
vim.keymap.set("t", "<esc>", "<c-\\><c-n>", { desc = "Keys: Exit from terminal insert mode" })

nmap("<leader>bn", ":bn<cr>", "Next Buffer")
nmap("<leader>bp", ":bp<cr>", "Buffer")
nmap("<leader>bd", ":bd<cr>", "Buffer")
nmap("<leader>bD", ":bd!<cr>", "Delete Buffer (forced)")

nmap("<leader>qc", ":ccl<cr>", "Close Quickfix")

-- Scroll with centered cursor
nmap("<c-u>", "<c-u>zz", "Scroll up")
nmap("<c-d>", "<c-d>zz", "Scroll down")

-- Move lines
nmap("<a-j>", "<cmd>m .+1<cr>==", "Move line down")
nmap("<a-k>", "<cmd>m .-2<cr>==", "Move line up")
imap("<a-j>", "<esc><cmd>m .+1<cr>==gi", "Move line down")
imap("<a-k>", "<esc><cmd>m .-2<cr>==gi", "Move line up")
vmap("<a-j>", ":m '>+1<cr>gv=gv", "Move line down")
vmap("<a-k>", ":m '<-2<cr>gv=gv", "Move line up")
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Homegrown ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
nmap("<leader>#", require("config.macros").CreateCommentHeader, "Create comment header")
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ LSP ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
M.lsp_set_mappings = function(buffer)
  local nmap = function(keys, func, desc)
    vim.keymap.set('n', keys, func, { buffer = buffer, desc = 'LSP: ' .. desc })
  end

  local function list_workspace_folders()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end

  nmap('<leader>lr', vim.lsp.buf.rename, 'Rename')
  nmap('<leader>lf', vim.lsp.buf.format, 'Format Buffer')
  nmap('<leader>la', vim.lsp.buf.code_action, 'Code Action')
  nmap('<leader>ll', vim.lsp.codelens.run, 'CodeLens')

  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  nmap('gd', vim.lsp.buf.definition, 'Definition')
  nmap('gD', vim.lsp.buf.declaration, 'Declaration')
  nmap('gi', vim.lsp.buf.implementation, 'Implementation')
  nmap('go', vim.lsp.buf.type_definition, 'Type Definition')
  nmap('gr', vim.lsp.buf.references, 'References')
  nmap('gs', vim.lsp.buf.signature_help, 'Signature Help')
  nmap('gl', vim.diagnostic.open_float, 'Show Diagnostic')
  nmap('[d', vim.diagnostic.goto_prev, 'Previous Diagnostic')
  nmap(']d', vim.diagnostic.goto_next, 'Next Diagnostic')

  nmap('<leader>lwa', vim.lsp.buf.add_workspace_folder, 'Add Workspace Folder')
  nmap('<leader>lwr', vim.lsp.buf.remove_workspace_folder, 'Remove Workspace Folder')
  nmap('<leader>lwl', list_workspace_folders, 'List Workspace Folders')
end
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Trouble ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
M.trouble_get_mappings = function()
  local function d(x)
    return "Trouble: " .. x
  end
  return {
    { "<leader>tt", "<cmd>TroubleToggle<cr>",                 desc = d("Toggle") },
    { "<leader>tD", "<cmd>Trouble workspace_diagnostics<cr>", desc = d("Workspace Diagnostics") },
    { "<leader>td", "<cmd>Trouble document_diagnostics<cr>",  desc = d("Document Diagnostics") },
    { "<leader>tl", "<cmd>Trouble loclist <cr>",              desc = d("Location List") },
    { "<leader>tq", "<cmd>Trouble quickfix<cr>",              desc = d("QuickFix") },
    { "<leader>tr", "<cmd>Trouble lsp_references<cr>",        desc = d("LSP References") },
    { "<leader>tR", "<cmd>TroubleRefresh<cr>",                desc = d("Refresh") },
    { "<leader>tc", "<cmd>TroubleClose<cr>",                  desc = d("Close") },
  }
end
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ Flash ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
M.flash_get_mappings = function()
  local function d(x)
    return "Flash: " .. x
  end
  return {
    { "s", mode = { "n", },     function() require("flash").jump() end,       desc = d("Jump") },
    { "S", mode = { "n", "o" }, function() require("flash").treesitter() end, desc = d("Treesitter") },
    { "r", mode = { "o" },      function() require("flash").remote() end,     desc = d("Remote") },
  }
end
-- ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ TreeSJ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~ --
M.treesj_get_mappings = function()
  return { {
    "<leader>m",
    mode = { "n" },
    function()
      require("treesj").toggle()
    end,
    desc = "TreeSJ: Toggle"
  } }
end
return M
