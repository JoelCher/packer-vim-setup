-- This file can be loaded by calling `lua require('plugins')` from your init.vim

-- Only required if you have packer configured as `opt`
vim.cmd([[packadd packer.nvim]])

vim.cmd([[colorscheme tokyonight]])

return require("packer").startup(function(use)
	-- Packer can manage itself
	use("wbthomason/packer.nvim")
	use("nvim-tree/nvim-web-devicons")
	use("nvim-lua/plenary.nvim")
	use("ThePrimeagen/harpoon")
	use("neovim/nvim-lspconfig") -- LSP configurations
	use("hrsh7th/nvim-cmp") -- Completion plugin
	use("hrsh7th/cmp-nvim-lsp") -- LSP source for nvim-cmp
	use("L3MON4D3/LuaSnip") -- Snippets engine
	use("williamboman/mason.nvim") -- Package manager for LSPs
	use("williamboman/mason-lspconfig.nvim") -- Bridges Mason and LSPConfig
	use("L3MON4D3/LuaSnip") -- Snippet engine
	use("folke/neodev.nvim") -- Lua-specific enhancements
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
end)
