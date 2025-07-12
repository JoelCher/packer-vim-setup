vim.opt.number = true -- Show absolute line numbers
vim.opt.relativenumber = true -- Show relative line numbers
vim.opt.mouse = "a" -- Enable mouse support in all modes
vim.opt.expandtab = true -- Convert tabs to spaces
vim.opt.shiftwidth = 4 -- Number of spaces for indentation
vim.opt.tabstop = 4 -- Number of spaces per tab
vim.opt.softtabstop = 4 -- Number of spaces inserted when pressing Tab
vim.opt.smartindent = true -- Auto-indent when starting a new line
vim.opt.expandtab = false -- Use real tabs
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.wrap = true -- Enable line wrapping
vim.opt.linebreak = true -- Wrap without breaking words
vim.opt.breakindent = true -- Indent wrapped lines to match indentation
vim.opt.hlsearch = true -- Highlight search results
vim.opt.incsearch = true -- Show results as you type
vim.opt.ignorecase = true -- Ignore case when searching
vim.opt.smartcase = true -- Use case-sensitive search if uppercase letters are used
vim.opt.splitright = true -- Open vertical splits to the right
vim.opt.splitbelow = true -- Open horizontal splits below
vim.opt.backup = false
vim.opt.swapfile = false -- Disable swap files
vim.opt.scrolloff = 8 -- Keep at least 8 lines above/below cursor
vim.opt.sidescrolloff = 8 -- Keep at least 8 columns left/right of cursor
vim.opt.clipboard = "unnamedplus"
vim.opt.signcolumn = "yes:1"
--vim.opt.cursorline = true
vim.opt.showmatch = true
vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"
-- vim.opt.spell = true

vim.keymap.set("n", "<C-s>", ":w<CR>", { noremap = true, silent = true }) -- Save file
vim.keymap.set("i", "<C-s>", "<C-c>:w<CR>", { noremap = true, silent = true }) -- Save file
vim.keymap.set("n", "<leader>q", ":q<CR>", { noremap = true, silent = true }) -- Quit file
vim.keymap.set("n", "<leader>x", ":x<CR>", { noremap = true, silent = true }) -- Save & quit

-- configure telescope
local find_files = function()
	require("telescope.builtin").find_files({
		file_ignore_patterns = { "node_modules", "%.log", "external" },
	})
end
vim.keymap.set("n", "<leader>sf", find_files, { noremap = true, silent = true }) -- Find files
vim.keymap.set("n", "<leader>sg", ":Telescope live_grep<CR>", { noremap = true, silent = true }) -- Search in files
vim.keymap.set("n", "<leader>sb", ":Telescope buffers<CR>", { noremap = true, silent = true }) -- Find open buffers
vim.keymap.set("n", "<leader>sh", ":Telescope help_tags<CR>", { noremap = true, silent = true }) -- Find help docsvim.keymap.set("n", "gd", "<CMD>Telescope lsp_definition<CR>")
vim.keymap.set("n", "gd", "<CMD>Telescope lsp_definitions<CR>")

vim.keymap.set("n", "<leader>a", function()
	require("harpoon.mark").add_file()
end)
vim.keymap.set("n", "<C-e>", function()
	require("harpoon.ui").toggle_quick_menu()
end)

vim.cmd("highlight! HarpoonInactive guibg=NONE guifg=#63698c")
vim.cmd("highlight! HarpoonActive guibg=NONE guifg=white")
vim.cmd("highlight! HarpoonNumberActive guibg=NONE guifg=#7aa2f7")
vim.cmd("highlight! HarpoonNumberInactive guibg=NONE guifg=#7aa2f7")
vim.cmd("highlight! TabLineFill guibg=NONE guifg=white")

require("harpoon").setup({
	global_settings = {
		-- sets the marks upon calling `toggle` on the ui, instead of require `:w`.
		save_on_toggle = false,

		-- saves the harpoon file upon every change. disabling is unrecommended.
		save_on_change = true,

		-- sets harpoon to run the command immediately as it's passed to the terminal when calling `sendCommand`.
		enter_on_sendcmd = false,

		-- closes any tmux windows harpoon that harpoon creates when you close Neovim.
		tmux_autoclose_windows = false,

		-- filetypes that you want to prevent from adding to the harpoon list menu.
		excluded_filetypes = { "harpoon" },

		-- set marks specific to each git branch inside git repository
		mark_branch = false,

		-- enable tabline with harpoon marks
		tabline = false,
		tabline_prefix = "   ",
		tabline_suffix = "   ",
	},
})

-- formatting
vim.api.nvim_create_user_command("Fmt", function(args)
	local ft = vim.bo.filetype
	local react_filetypes = {
		javascriptreact = true,
		typescriptreact = true,
		jsx = true,
		tsx = true,
	}
	if react_filetypes[ft] then
		require("conform").format({ bufnr = args.buf, formatters = { "prettier" } })
	else
		vim.lsp.buf.format({
			async = true,
		})
	end
end, {})

vim.keymap.set("n", "<C-f>", ":Fmt<CR>")
