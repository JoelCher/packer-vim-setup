require("plugins")
require("options")

-- Ensure LSP is installed using Mason
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installed = { "clangd" }, -- Automatically install clangd
})

-- LSP Configuration
local lspconfig = require("lspconfig")

-- Setup clangd for C++ support
lspconfig.clangd.setup({
	cmd = { "clangd" },
	filetypes = { "c", "cpp", "objc", "objcpp" },
	root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

-- Keybindings for LSP
local opts = { noremap = true, silent = true, buffer = bufnr }
vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)

local cmp = require("cmp")

cmp.setup({
	snippet = {
		expand = function(args)
			require("luasnip").lsp_expand(args.body)
		end,
	},
	mapping = {
		["<Tab>"] = cmp.mapping.select_next_item(),
		["<S-Tab>"] = cmp.mapping.select_prev_item(),
		["<CR>"] = cmp.mapping.confirm({ select = true }),
	},
	sources = {
		{ name = "nvim_lsp" },
	},
})
-- Load Neodev (for better Lua support in Neovim)
require("neodev").setup()

lspconfig.lua_ls.setup({
	settings = {
		Lua = {
			runtime = { version = "LuaJIT" }, -- Use LuaJIT for Neovim
			diagnostics = { globals = { "vim" } }, -- Recognize `vim` as a global
			workspace = {
				library = {
					vim.fn.expand("$VIMRUNTIME/lua"), -- Include Neovim runtime files
					vim.fn.stdpath("config") .. "/lua",
				},
				checkThirdParty = false, -- Disable third-party warnings
			},
			telemetry = { enable = false },
		},
	},
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

--config oil.nvim
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		-- Conform will run multiple formatters sequentially
		-- python = { "isort", "black" },
		-- You can customize some of the format options for the filetype (:help conform.format)
		rust = { "rustfmt", lsp_format = "fallback" },
		-- Conform will run the first available formatter
		javascript = { "prettierd", "prettier", stop_after_first = true },
		cpp = { "clang-format" },
	},
})

vim.api.nvim_create_autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})
require("telescope").load_extension("harpoon")
require("mini.move").setup()
