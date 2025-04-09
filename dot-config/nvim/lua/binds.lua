-- Utility functions

vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]])

vim.keymap.set("v", "<leader>ei", function()
  -- Get visual selection
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local lines = vim.fn.getline(start_pos[2], end_pos[2])

  if #lines == 0 then
    return
  end

  -- Trim the selection range
  lines[1] = lines[1]:sub(start_pos[3])
  lines[#lines] = lines[#lines]:sub(1, end_pos[3])
  local code = table.concat(lines, "\n")

  vim.notify(vim.inspect(code))

  local f = load("return " .. code, "Code", "t", _G)

  if f ~= nil then
    local ok, result = pcall(f)
    if ok then
      vim.notify(vim.inspect(result))
    end
  end
end, { desc = "Eval and inspect visual selection" })

local kms = function(modes, keys, fn, desc)
  vim.keymap.set(modes, keys, fn, { desc = desc, noremap = true, silent = true })
end

-- LSP
local binds_lsp = function()
  local buf = vim.lsp.buf
  local binds = {
    { "n", "gD",         buf.declaration,    "[g]o to [D]eclaration" },
    { "n", "gh",         buf.hover,          "[g]et [h]over info" },
    { "n", "gs",         buf.signature_help, "[g]et [s]ignature" },
    { "n", "<leader>lr", buf.rename,         "[l]sp [r]ename" },
    { "n", "<leader>la", buf.code_action,    "[l]sp code [a]ctions" },
  }

  local function set_lsp_keymaps(bufnr)
    if vim.b[bufnr].lsp_keymaps_set then
      return
    end
    for _, b in ipairs(binds) do
      kms(b[1], b[2], b[3], "LSP: " .. b[4])
    end
    vim.b[bufnr].lsp_keymaps_set = true
  end

  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local client = vim.lsp.get_client_by_id(args.data.client_id)
      if not client then
        return
      end

      local bufnr = args.buf
      set_lsp_keymaps(bufnr)

      vim.notify(string.format("lsp attached: %s %d", client, bufnr))

      if client.supports_method("textDocument/formatting") then
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({ bufnr = bufnr, id = client.id })
          end,
        })
      end
    end,
  })
end

-- SETUP
binds_lsp()
