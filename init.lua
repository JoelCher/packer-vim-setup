require("plugins")
require("options")

-- Ensure LSP is installed using Mason
require("mason").setup()
require("mason-lspconfig").setup({
	ensure_installer = { "clangd", "arduino_language_server", "html-lsp", "htmx-lsp", "gopls" }, -- Automatically install clangd
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

--Enable (broadcasting) snippet capability for completion
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

vim.lsp.enable("golangci_lint_ls")
vim.lsp.enable("gopls")

vim.lsp.config("html", {
	capabilities = capabilities,
	filetypes = { "html", "templ", "tmpl" },
})

vim.lsp.enable("tailwindcss")
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
vim.lsp.enable("htmx")
lspconfig.htmx.setup({})
vim.lsp.enable("cssls")

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
-- lspconfig.ts_ls.setup({
-- 	on_attach = function(client, bufnr)
-- 		-- Keybindings for LSP
-- 		local opts = { noremap = true, silent = true, buffer = bufnr }
-- 		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
-- 		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
-- 		vim.keymap.set("n", "K", function()
-- 			vim.lsp.buf.hover()
-- 		end, opts)
--
-- 		-- Disable formatting in favor of a dedicated formatter like `null-ls`
-- 		client.server_capabilities.documentFormattingProvider = false
-- 	end,
-- 	capabilities = require("cmp_nvim_lsp").default_capabilities(), -- if using nvim-cmp
-- })

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

require("typescript-tools").setup({
	on_attach = function() end,
	handlers = {},
	settings = {
		-- spawn additional tsserver instance to calculate diagnostics on it
		separate_diagnostic_server = true,
		-- "change"|"insert_leave" determine when the client asks the server about diagnostic
		publish_diagnostic_on = "insert_leave",
		-- array of strings("fix_all"|"add_missing_imports"|"remove_unused"|
		-- "remove_unused_imports"|"organize_imports") -- or string "all"
		-- to include all supported code actions
		-- specify commands exposed as code_actions
		expose_as_code_action = {},
		-- string|nil - specify a custom path to `tsserver.js` file, if this is nil or file under path
		-- not exists then standard path resolution strategy is applied
		tsserver_path = nil,
		-- specify a list of plugins to load by tsserver, e.g., for support `styled-components`
		-- (see 💅 `styled-components` support section)
		tsserver_plugins = {},
		-- this value is passed to: https://nodejs.org/api/cli.html#--max-old-space-sizesize-in-megabytes
		-- memory limit in megabytes or "auto"(basically no limit)
		tsserver_max_memory = "auto",
		-- described below
		tsserver_format_options = {},
		tsserver_file_preferences = {},
		-- locale of all tsserver messages, supported locales you can find here:
		-- https://github.com/microsoft/TypeScript/blob/3c221fc086be52b19801f6e8d82596d04607ede6/src/compiler/utilitiesPublic.ts#L620
		tsserver_locale = "en",
		-- mirror of VSCode's `typescript.suggest.completeFunctionCalls`
		complete_function_calls = false,
		include_completions_with_insert_text = true,
		-- CodeLens
		-- WARNING: Experimental feature also in VSCode, because it might hit performance of server.
		-- possible values: ("off"|"all"|"implementations_only"|"references_only")
		code_lens = "off",
		-- by default code lenses are displayed on all referencable values and for some of you it can
		-- be too much this option reduce count of them by removing member references from lenses
		disable_member_code_lens = true,
		-- JSXCloseTag
		-- WARNING: it is disabled by default (maybe you configuration or distro already uses nvim-ts-autotag,
		-- that maybe have a conflict if enable this feature. )
		jsx_close_tag = {
			enable = false,
			filetypes = { "javascriptreact", "typescriptreact" },
		},
	},
})
