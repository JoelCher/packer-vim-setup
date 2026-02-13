-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd([[packadd packer.nvim]])
vim.cmd([[colorscheme torte]])

return require("packer").startup(function(use)
	-- Packer can manage itself
	--
	-- use("null-ls")
	-- use("my-plugin")
	-- use({ "~/plugins/focus-mode.nvim" })
	-- use({ "~/plugins/nvim-encrypt.nvim" })
	use("tpope/vim-fugitive")
	use({
		"rose-pine/neovim",
		config = function()
			-- vim.cmd("colorscheme rose-pine")
		end,
	})
	use("fatih/vim-go")
	use("wbthomason/packer.nvim")
	use("nvim-tree/nvim-web-devicons")
	use("nvim-lua/plenary.nvim")
	use("ThePrimeagen/harpoon")
	use("neovim/nvim-lspconfig")            -- LSP configurations
	use("hrsh7th/nvim-cmp")                 -- Completion plugin
	use("hrsh7th/cmp-nvim-lsp")             -- LSP source for nvim-cmp
	use("williamboman/mason.nvim")          -- Package manager for LSPs
	use("williamboman/mason-lspconfig.nvim") -- Bridges Mason and LSPConfig
	use("L3MON4D3/LuaSnip")                 -- Snippet engine
	use("folke/neodev.nvim")                -- Lua-specific enhancements
	use("folke/tokyonight.nvim")
	use("echasnovski/mini.nvim")
	use("echasnovski/mini.move")
	use({
		"folke/trouble.nvim",
		config = function()
			require("trouble").setup({
				opts = {}, -- for default options, refer to the configuration section for custom setup.
				cmd = "Trouble",
				keys = {
					{
						"<leader>xx",
						"<cmd>Trouble diagnostics toggle<cr>",
						desc = "Diagnostics (Trouble)",
					},
					{
						"<leader>xX",
						"<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
						desc = "Buffer Diagnostics (Trouble)",
					},
					{
						"<leader>cs",
						"<cmd>Trouble symbols toggle focus=false<cr>",
						desc = "Symbols (Trouble)",
					},
					{
						"<leader>cl",
						"<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
						desc = "LSP Definitions / references / ... (Trouble)",
					},
					{
						"<leader>xL",
						"<cmd>Trouble loclist toggle<cr>",
						desc = "Location List (Trouble)",
					},
					{
						"<leader>xQ",
						"<cmd>Trouble qflist toggle<cr>",
						desc = "Quickfix List (Trouble)",
					},
				},
			})
		end,
	})
	use({
		"stevearc/oil.nvim",
		config = function()
			require("oil").setup()
		end,
	})
	use({
		"nvim-telescope/telescope.nvim",
		requires = { "nvim-lua/plenary.nvim" },
		config = function()
			require("telescope").setup({
				defualts = {
					file_ignore_patterns = {
						"node_modules",
						".git/",
						"%.lock",
						"%.log",
						"%.cache",
						"build/",
						"external",
					},
				},
			})
		end,
	})
	use({
		"numToStr/Comment.nvim",
		config = function()
			require("Comment").setup()
		end,
	})
	use({
		"stevearc/conform.nvim",
		branch = "nvim-0.9",
		config = function()
			require("conform").setup()
		end,
	})
	use({
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({})
		end,
	})
	use({
		"windwp/nvim-ts-autotag",
		event = "InsertEnter",
		config = function()
			require("nvim-ts-autotag").setup({
				opts = {
					-- Defaults
					enable_close = true,      -- Auto close tags
					enable_rename = true,     -- Auto rename pairs of tags
					enable_close_on_slash = false, -- Auto close on trailing </
				},
				-- Also override individual filetype configs, these take priority.
				-- Empty by default, useful if one of the "opts" global settings
				-- doesn't work well in a specific filetype
				per_filetype = {
					["html"] = {
						enable_close = false,
					},
				},
			})
		end,
	})
	use({
		"nvim-treesitter/nvim-treesitter",
		config = function()
			require("nvim-treesitter.configs").setup({
				-- A list of parser names, or "all" (the listed parsers MUST always be installed)
				ensure_installed = { "ts", "html", "c", "lua", "vim", "vimdoc", "query", "markdown", "markdown_inline" },

				-- Install parsers synchronously (only applied to `ensure_installed`)
				sync_install = false,

				-- Automatically install missing parsers when entering buffer
				-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
				auto_install = true,

				-- List of parsers to ignore installing (or "all")
				ignore_install = { "javascript" },

				---- If you need to change the installation directory of the parsers (see -> Advanced Setup)
				-- parser_install_dir = "/some/path/to/store/parsers", -- Remember to run vim.opt.runtimepath:append("/some/path/to/store/parsers")!

				highlight = {
					enable = true,

					-- NOTE: these are the names of the parsers and not the filetype. (for example if you want to
					-- disable highlighting for the `tex` filetype, you need to include `latex` in this list as this is
					-- the name of the parser)
					-- list of language that will be disabled
					disable = { "c", "rust" },
					-- Or use a function for more flexibility, e.g. to disable slow treesitter highlight for large files
					disable = function(lang, buf)
						local max_filesize = 100 * 1024 -- 100 KB
						local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
						if ok and stats and stats.size > max_filesize then
							return true
						end
					end,

					-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
					-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
					-- Using this option may slow down your editor, and you may see some duplicate highlights.
					-- Instead of true it can also be a list of languages
					additional_vim_regex_highlighting = false,
				},
			})
		end,
	})
end)
