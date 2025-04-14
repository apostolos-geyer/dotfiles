local M = {}

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

local when = require("nvprofile.predicates").when

local flat_merge = require("helpers").flat_merge

---@type { [boolean | table | string]: fun(): nil}
M = {
    [when.always] = function()
        keymap({ "n", "v" }, "<Space>", "", opts)

        --- reselect block after indenting
        keymap("v", "<", "<gv", opts)
        keymap("v", ">", ">gv", opts)

        --- move blocks of text
        keymap("v", "J", ":m .+1<CR>==", opts)
        keymap("v", "K", ":m .-2<CR>==", opts)
        keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
        keymap("x", "K", ":move '<-2<CR>gv-gv", opts)

        --- dont overwrite clipboard when pasting
        --- over visual selection
        keymap("v", "p", '"_dP', opts)

        --- remove highlight after search
        keymap("n", "<Esc>", "<Esc>:noh<CR>", opts)

        keymap("n", "<leader>Glg", function()
            require("snacks").lazygit()
        end, flat_merge({ opts, desc = "[G]it (LazyGit)" }))
        keymap("n", "<leader>Gbr", function()
            require("snacks").gitbrowse()
        end, flat_merge({ opts, desc = "[G]it (Browser)" }))
    end,

    [when.any_of("terminal", "neovide")] = function()
        --- make escape work in term
        keymap("t", "<Esc>", [[<C-\><C-n>]], opts)

        --- buffer stuff
        keymap("n", "<leader>c", "<CMD>bdelete<CR>", { desc = "[c]lose buffer", noremap = true })
        keymap("n", "<leader>C", "<CMD>bdelete!<CR>", { desc = "[c]lose buffer!", noremap = true })
        keymap("n", "<leader>bb", "<CMD>BufferLinePick<CR>", flat_merge({ opts, desc = "[b]uffer pick" }))
        keymap(
            "n",
            "<leader>blc",
            "<CMD>BufferLinePickClose<CR>",
            flat_merge({ opts, desc = "[b]uffer [l]ine [c]lose" })
        )
        keymap("n", "b]", "<CMD>BufferLineCycleNext<CR>", flat_merge({ opts, desc = "next buffer" }))
        keymap("n", "b[", "<CMD>BufferLineCyclePrev<CR>", flat_merge({ opts, desc = "prev buffer" }))

        -- file browser
        keymap("n", "<leader>e", "<CMD>Oil<CR>", flat_merge({ opts, desc = "[e]xplorer (oil)" }))

        -- 🔍 Fuzzy find words in current buffer (dropdown with preview)
        keymap("n", "<leader>Fw", function()
            local builtin = require("telescope.builtin")
            local themes = require("telescope.themes")
            builtin.current_buffer_fuzzy_find(themes.get_dropdown({
                winblend = 10,
                previewer = true,
                mirror = true,
            }))
        end, flat_merge({ desc = "[F]uzz [w]ords (in current file)", opts }))

        -- 📁 Find files using `fd` (with hidden + dropdown theme)
        keymap("n", "<leader>ff", function()
            local builtin = require("telescope.builtin")
            local themes = require("telescope.themes")
            builtin.find_files(themes.get_dropdown({
                winblend = 10,
                previewer = true,
                mirror = true,
                hidden = true,
            }))
        end, flat_merge({ desc = "[f]ind [f]iles", opts }))

        -- 🌳 Treesitter symbols
        keymap("n", "<leader>fst", function()
            require("telescope.builtin").treesitter()
        end, flat_merge({ desc = "[f]ind [s]ymbols with [t]reesitter", opts }))

        -- 🔤 Grep string under cursor or visual selection
        keymap({ "n", "v" }, "<leader>fw", function()
            require("telescope.builtin").grep_string()
        end, flat_merge({ desc = "[f]ind [w]ords (grep)", opts }))

        -- 🌍 Live grep through workspace
        keymap("n", "<leader>fa", function()
            require("telescope.builtin").live_grep()
        end, flat_merge({ desc = "[f]ind [a]nywhere (ripgrep)", opts }))

        -- 🧠 LSP definitions/references/etc
        keymap("n", "gd", function()
            require("telescope.builtin").lsp_definitions()
        end, flat_merge({ desc = "[g]o to [d]efinition", opts }))

        keymap("n", "gr", function()
            require("telescope.builtin").lsp_references()
        end, flat_merge({ desc = "[g]et [r]eferences", opts }))

        keymap("n", "gi", function()
            require("telescope.builtin").lsp_implementations()
        end, flat_merge({ desc = "[g]o to [i]mplementation", opts }))

        keymap("n", "gt", function()
            require("telescope.builtin").lsp_type_definitions()
        end, flat_merge({ desc = "[g]o to [t]ype definition", opts }))

        -- 🗂 Symbols
        keymap("n", "<leader>ls", function()
            require("telescope.builtin").lsp_document_symbols()
        end, flat_merge({ desc = "[l]ist [s]ymbols in document", opts }))

        keymap("n", "<leader>lS", function()
            require("telescope.builtin").lsp_workspace_symbols()
        end, flat_merge({ desc = "[l]ist [S]ymbols in workspace", opts }))

        -- 🚨 Diagnostics
        keymap("n", "<leader>ld", function()
            require("telescope.builtin").diagnostics({ bufnr = 0 })
        end, flat_merge({ desc = "[l]sp [d]iagnostics (current buffer)", opts }))

        keymap("n", "<leader>lD", function()
            require("telescope.builtin").diagnostics()
        end, flat_merge({ desc = "[l]anguage server [D]iagnostics (all buffers)", opts }))
    end,

    vscode = function()
        local Action = function(name)
            return function()
                require("vscode").action(name)
            end
        end

        keymap(
            "n",
            "<leader>fa",
            Action("workbench.action.findInFiles"),
            flat_merge({ desc = "[f]ind word [a]nywhere", opts })
        )

        keymap("n", "<leader>fw", Action("action.find"), flat_merge({ desc = "[f]ind [w]ord", opts }))
        keymap("n", "<leader>ff", Action("workbench.action.quickOpen"), flat_merge({ desc = "[f]ind [f]ile", opts }))
        keymap(
            "n",
            "<leader>e",
            Action("workbench.action.toggleSidebarVisibility"),
            flat_merge({ desc = "[e]xplorer", opts })
        )
        keymap(
            "n",
            "<leader>c",
            Action("workbench.action.closeActiveEditor"),
            flat_merge({ desc = "[c]lose buffer", opts })
        )
        keymap(
            "n",
            "<leader>C",
            Action("workbench.action.revertAndCloseActiveEditor"),
            flat_merge({ desc = "[C]lose buffer!", opts })
        )
    end,
}

return M
