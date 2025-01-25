--- @param dest table The destination table to append to.
--- @param src table The source table to append from.
local extend = function(dest, src)
    table.move(src, 1, #src, #dest + 1, dest)
end

local kms = function(btbl, modes, keys, fn, desc)
    for _, mode in ipairs(modes) do
        table.insert(btbl, { mode = mode, keys = keys, desc = desc })
    end
    vim.keymap.set(modes, keys, fn, { desc = desc, noremap = true, silent = true })
end

-- LSP -- keep in sync with programming.lua lsp init
local binds_lsp = function()
    local telescope_builtin = require("telescope.builtin")
    local buf = vim.lsp.buf
    local binds = {
        -- LSP Navigation
        [{ key = "gd", desc = "[g]o to [d]efinition" }] = telescope_builtin.lsp_definitions,
        [{ key = "gD", desc = "[g]o to [D]eclaration" }] = buf.declaration,
        [{ key = "gr", desc = "[g]et [r]eferences" }] = telescope_builtin.lsp_references,
        [{ key = "gi", desc = "[g]o to [i]mplementation" }] = telescope_builtin.lsp_implementations,
        [{ key = "gt", desc = "[g]o to [t]ype definition" }] = telescope_builtin.lsp_type_definitions,
        [{ key = "gh", desc = "[g]et [h]over info" }] = buf.hover,
        [{ key = "gs", desc = "[g]et [s]ignature" }] = buf.signature_help,
        [{ key = "<leader>lr", desc = "[l]sp [r]ename" }] = buf.rename,
        [{ key = "<leader>ls", desc = "[l]ist [s]ymbols in document" }] = telescope_builtin.lsp_document_symbols,
        [{ key = "<leader>lS", desc = "[l]ist [S]ymbols in workspace" }] = telescope_builtin.lsp_workspace_symbols,
        [{ key = "<leader>la", desc = "[l]sp code [a]ctions" }] = buf.code_action,
        [{ key = "<leader>ld", desc = "[l]sp [d]iagnostics (current buffer)" }] = function()
            telescope_builtin.diagnostics({ bufnr = 0 })
        end,
        [{ key = "<leader>lD", desc = "[l]anguage server [D]iagnostics (all buffers)" }] = telescope_builtin.diagnostics,
    }
    -- Function to set LSP keybindings
    local function set_lsp_keymaps(bufnr)
        -- if keymaps of this buffer are already set we
        -- dont need to do it again
        if vim.b[bufnr].lsp_keymaps_set then
            return
        end
        -- Set the keybindings for the attached buffer
        for key_data, fn in pairs(binds) do
            local key, desc = key_data.key, "LSP: " .. key_data.desc
            vim.keymap.set("n", key, fn, { noremap = true, silent = true, desc = desc, buffer = bufnr })
        end

        vim.b[bufnr].lsp_keymaps_set = true -- mark keymaps as set for buffer
    end

    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            -- print("Client attached: ", vim.inspect(client))
            if not client then
                return
            end

            -- If LSP supports formatting
            if client.supports_method("textDocument/formatting") then
                -- Right before save, call vim.lsp.buf.format
                local thisbuf = args.buf
                -- print("Setting LSP keymaps for buffer: ", buf)
                set_lsp_keymaps(thisbuf)
                vim.api.nvim_create_autocmd("BufWritePre", {
                    buffer = thisbuf,
                    callback = function()
                        vim.lsp.buf.format({ bufnr = thisbuf, id = client.id })
                    end,
                })
            end
        end,
    })

    local btbl = {
        { mode = "n", keys = "g", desc = "goto/get..." },
        {
            mode = "n",
            keys = "<leader>l",
            desc = "language server...",
        },
    }
    for info, _ in pairs(binds) do
        table.insert(btbl, { mode = "n", keys = info.key, desc = info.desc })
    end
    return btbl
end

-- BUFFERLINE --
local binds_bufferline = function()
    local btbl = {}
    local binds = {
        [{ keys = "<leader>bb", desc = "[b]uffer pick" }] = "<CMD>BufferLinePick<CR>",
        [{ keys = "<leader>c", desc = "[c]lose buffer (current)" }] = "<CMD>bdelete<CR>",
        [{ keys = "<leader>blc", desc = "[b]uffer [l]ine [c]lose (close from line)" }] = "<CMD>BufferLinePickClose<CR>",
        [{ keys = "<leader>b]", desc = "next buffer" }] = "<CMD>BufferLineCycleNext<CR>",
        [{ keys = "<leader>b[", desc = "previous buffer" }] = "<CMD>BufferLineCyclePrev<CR>",
    }
    for data, fn in pairs(binds) do
        kms(btbl, { "n" }, data.keys, fn, data.desc)
    end
    table.insert(btbl, { mode = "n", keys = "b", desc = "buffer..." })
    return btbl
end

-- TELESCOPE --
local binds_telescope = function()
    local btbl = {}
    local builtin = require("telescope.builtin")
    local themes = require("telescope.themes")
    local binds = {
        [{ keys = "<leader>Fw", desc = "[F]uzz [w]ords (in current file)" }] = function()
            builtin.current_buffer_fuzzy_find(themes.get_dropdown({
                winblend = 10,
                previewer = true,
                mirror = true,
            }))
        end,
        [{ keys = "<leader>ff", desc = "[f]ind [f]iles" }] = function()
            builtin.fd(themes.get_dropdown({
                winblend = 10,
                previewer = true,
                mirror = true,
                hidden = true,
            }))
        end,
        [{ keys = "<leader>fst", desc = "[f]ind [s]ymbols with [t]reesitter" }] = builtin.treesitter,
        [{ keys = "<leader>fw", desc = "[f]ind [w]ords (grep)", modes = { "n", "v" } }] = builtin.grep_string,
        [{ keys = "<leader>fiw", desc = "[f]ind [i]n [w]orkspace (ripgrep)" }] = builtin.live_grep,
    }
    for data, fn in pairs(binds) do
        kms(btbl, data.modes or { "n" }, data.keys, fn, data.desc)
    end
    extend(btbl, {
        { keys = "<leader>f", desc = "[f]ind...", mode = "n" },
        { keys = "<leader>f", desc = "[f]ind...", mode = "v" },
    })
    return btbl
end

--- OIL ---
local binds_oil = function()
    vim.keymap.set("n", "<leader>e", "<CMD>Oil<CR>", { desc = "[e]xplorer (oil)" })
    return {}
end

--- MINICLUE SETUP ---

--- mini clue doesnt provide this for some reason
local binds_visual = function()
    local base = { { keys = "a", desc = "around: " }, { keys = "i", desc = "in: " } }
    local textobjs = {
        { keys = "w", desc = "word ([a-zA-Z_])" },
        { keys = "W", desc = "word (contiguous block of characters)" },
        { keys = "s", desc = "sentence" },
        { keys = "p", desc = "paragraph" },
        { keys = "b", desc = "() block" },
        { keys = "B", desc = "[] block" },
        { keys = "t", desc = "<tag> block" },
        { keys = "<", desc = "<> block" },
        { keys = "[", desc = "[] block" },
        { keys = '"', desc = '"string"' },
        { keys = "'", desc = "'string'" },
        { keys = "`", desc = "`string`" },
        { keys = "f", desc = "function" },
        { keys = "c", desc = "class" },
        { keys = "l", desc = "loop" },
    }
    local tbl = {}
    for _, grp in ipairs(base) do
        table.insert(tbl, { mode = "v", keys = grp.keys, desc = grp.desc })
        for _, to in ipairs(textobjs) do
            table.insert(tbl, { mode = "v", keys = grp.keys .. to.keys, desc = grp.desc .. " " .. to.desc })
        end
    end
    return tbl
end;

(function()
    local miniclue = require("mini.clue")
    local clues = {}
    for _, bfn in ipairs({ binds_oil, binds_visual, binds_bufferline, binds_telescope, binds_lsp }) do
        extend(clues, bfn())
    end
    extend(clues, {
        {
            { keys = "<leader>G", desc = "+[G]it...", mode = "n" },
            { keys = "<leader>Go", desc = "+[G]it [o]pen in..." },
        },
        -- Enhance this by adding descriptions for <Leader> mapping groups
        miniclue.gen_clues.builtin_completion(),
        miniclue.gen_clues.g(),
        miniclue.gen_clues.marks(),
        miniclue.gen_clues.registers(),
        miniclue.gen_clues.windows(),
        miniclue.gen_clues.z(),
    })

    miniclue.setup({
        triggers = {
            -- Leader triggers
            { mode = "n", keys = "<Leader>" },
            { mode = "x", keys = "<Leader>" },

            -- visual mode
            { mode = "v", keys = "<Leader>" },
            { mode = "v", keys = "i" },
            { mode = "v", keys = "a" },

            -- Built-in completion
            { mode = "i", keys = "<C-x>" },

            -- `g` key
            { mode = "n", keys = "g" },
            { mode = "x", keys = "g" },

            -- Buffer commands
            { mode = "n", keys = "b" },

            -- Marks
            { mode = "n", keys = "'" },
            { mode = "n", keys = "`" },
            { mode = "x", keys = "'" },
            { mode = "x", keys = "`" },

            -- Registers
            { mode = "n", keys = '"' },
            { mode = "x", keys = '"' },
            { mode = "i", keys = "<C-r>" },
            { mode = "c", keys = "<C-r>" },

            -- Window commands
            { mode = "n", keys = "<C-w>" },

            -- `z` key
            { mode = "n", keys = "z" },
            { mode = "x", keys = "z" },
        },
        clues = clues,
        window = {
            delay = 200,
            width = "auto",
        },
    })
end)()
