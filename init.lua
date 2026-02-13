require("plugins")
require("options")

-- Ensure LSP is installed using Mason
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installer = { "clangd", "arduino_language_server", "html-lsp", "htmx-lsp", "gopls", "vtsls", "lua_ls" },
})

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
-- LSP Configuration
local lspconfig = vim.lsp.config

-- Setup clangd for C++ support
lspconfig("clangd", {
	cmd = { "clangd", "--query-driver=/usr/bin/c++" },
	filetypes = { "c", "cpp", "objc", "objcpp" },
	-- root_dir = lspconfig.util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
	capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

local base_on_attach = vim.lsp.config.eslint.on_attach
vim.lsp.config("eslint", {
	on_attach = function(client, bufnr)
		if not base_on_attach then
			return
		end

		base_on_attach(client, bufnr)
		vim.api.nvim_create_autocmd("BufWritePre", {
			buffer = bufnr,
			command = "LspEslintFixAll",
		})
	end,
})
vim.lsp.enable("golangci_lint_ls")
vim.lsp.enable("gopls")

vim.lsp.config("html", {
	capabilities = capabilities,
	filetypes = { "html", "templ", "tmpl" },
})

vim.lsp.enable("tailwindcss")
vim.lsp.enable("pyright")
vim.filetype.add({
	extension = {
		templ = "html", -- or "gotmpl" if using Go templates
		tmpl = "html",
	},
})

vim.lsp.config("cssls", {
	capabilities = capabilities,
})

vim.lsp.enable("html")
-- vim.lsp.enable("htmx")
-- lspconfig("htmx", {})
vim.lsp.enable("cssls")

-- require("cssls").setup({})

lspconfig("arduino_language_server", {
	cmd = {
		"arduino-language-server",
		"-clangd",
		"/usr/bin/clangd",
		"-cli",
		"/usr/bin/arduino-cli",
		"-cli-config",
		"/home/joelcher/.arduino15/arduino-cli.yaml",
		"-fqbn",
		"arduino:avr:uno",
	},
	filetypes = { "arduino", "cpp", "c", "ino" },
	root_dir = require("lspconfig.util").root_pattern(".git", "*.ino", "compile_commands.json", ".pio"),

	capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

-- Keybindings for LSP
local opts = { noremap = true, silent = true, buffer = bufnr }
vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

vim.keymap.set("i", "<C-space>", cmp.mapping.complete(), { desc = "Trigger completion" })

-- Configure TypeScript Language Server (tsserver)
lspconfig("vtsls", {
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
	settings = {
		exclude = { "**/node_modules" },
	},
})

-- Load Neodev (for better Lua support in Neovim)
-- require("neodev").setup()

lspconfig("lua_ls", {
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
		Lua = { "stylua" },
		-- Conform will run multiple formatters sequentially
		python = { "isort", "black" },
		-- You can customize some of the format options for the filetype (:help conform.format)
		rust = { "rustfmt", lsp_format = "fallback" },
		-- Conform will run the first available formatter
		javascript = { "prettier", "prettierd", stop_after_first = true },
		cpp = { "clang-format" },
	},
})

require("telescope").load_extension("harpoon")
require("mini.move").setup()
