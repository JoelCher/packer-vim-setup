require("plugins")
require("options")

-- Ensure LSP is installed using Mason
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installer = { "clangd", "ts_ls", "arduino_language_server", "html-lsp" }, -- Automatically install clangd
})

-- LSP Configuration
local lspconfig = require("lspconfig")

-- Setup clangd for C++ support
lspconfig.clangd.setup({
	cmd = { "clangd", "--query-driver=/usr/bin/c++" },
	filetypes = { "c", "cpp", "objc", "objcpp" },
	root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

-- require("cssls").setup({})

lspconfig.arduino_language_server.setup({
	cmd = {
		"arduino-language-server",
		"-clangd",
		"/usr/bin/clangd",
		"-cli",
		"/usr/local/bin/arduino-cli",
		"-cli-config",
		"~/.arduino15/arduino-cli.yaml",
		"-fqbn",
		"arduino:avr:uno",
	},
	-- filetypes = { "cpp" },
	-- root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
	-- capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

-- Configure TypeScript Language Server (tsserver)
lspconfig.ts_ls.setup({
	on_attach = function(client, bufnr)
		-- Keybindings for LSP
		local opts = { noremap = true, silent = true, buffer = bufnr }
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "K", function()
			vim.lsp.buf.hover()
		end, opts)

		-- Disable formatting in favor of a dedicated formatter like `null-ls`
		client.server_capabilities.documentFormattingProvider = false
	end,
	capabilities = require("cmp_nvim_lsp").default_capabilities(), -- if using nvim-cmp
})

-- Keybindings for LSP
local opts = { noremap = true, silent = true, buffer = bufnr }
vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

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
