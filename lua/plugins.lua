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
