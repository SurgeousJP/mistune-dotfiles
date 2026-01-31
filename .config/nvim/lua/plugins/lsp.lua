return {
	-- tools
	{
		"mason-org/mason.nvim",
		opts = function(_, opts)
			vim.list_extend(opts.ensure_installed, {
				"stylua",
				"selene",
				"luacheck",
				"shellcheck",
				"shfmt",
				"tailwindcss-language-server",
				"typescript-language-server",
				"css-lsp",
			})
		end,
	},

	-- LSP configuration using native vim.lsp.config (Neovim 0.11+)
	{
		"neovim/nvim-lspconfig", -- Keep for Mason integration but use new config format
		config = function()
			-- Configure diagnostic display
			vim.diagnostic.config({
				virtual_text = {
					enabled = true,
					source = "if_many",
					prefix = "",
					format = function(diagnostic)
						return diagnostic.message
					end,
				},
				float = {
					enabled = true,
					source = "always",
					border = "rounded",
					header = "",
					prefix = "",
					format = function(diagnostic)
						local code = diagnostic.code or diagnostic.user_data and diagnostic.user_data.lsp.code
						if code then
							return string.format("%s [%s]", diagnostic.message, code)
						end
						return diagnostic.message
					end,
				},
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = "✘",
						[vim.diagnostic.severity.WARN] = "▲",
						[vim.diagnostic.severity.INFO] = "⚑",
						[vim.diagnostic.severity.HINT] = "⚑",
					},
				},
				underline = true,
				update_in_insert = false,
				severity_sort = true,
			})

			-- Configure LSP keymaps
			local function setup_keymaps(_, bufnr)
				local keymap = vim.keymap.set
				local opts = { buffer = bufnr, silent = true }
				
				keymap("n", "gD", vim.lsp.buf.declaration, vim.tbl_extend("force", opts, { desc = "Goto Declaration" }))
				keymap("n", "gd", function()
					-- DO NOT REUSE WINDOW
					require("telescope.builtin").lsp_definitions({ reuse_win = false })
				end, vim.tbl_extend("force", opts, { desc = "Goto Definition" }))
				keymap("n", "gr", "<cmd>Telescope lsp_references<cr>", vim.tbl_extend("force", opts, { desc = "References" }))
				keymap("n", "gI", "<cmd>Telescope lsp_implementations<cr>", vim.tbl_extend("force", opts, { desc = "Goto Implementation" }))
				keymap("n", "gy", "<cmd>Telescope lsp_type_definitions<cr>", vim.tbl_extend("force", opts, { desc = "Goto T[y]pe Definition" }))
				keymap("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover" }))
				keymap("i", "gK", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature Help" }))
				keymap("i", "<c-k>", vim.lsp.buf.signature_help, vim.tbl_extend("force", opts, { desc = "Signature Help" }))
				keymap({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code Action" }))
				keymap("n", "<leader>cA", function()
					vim.lsp.buf.code_action({
						context = {
							only = { "source" },
							diagnostics = {},
						},
					})
				end, vim.tbl_extend("force", opts, { desc = "Source Action" }))
				keymap("n", "<leader>cr", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
				
				-- Diagnostic keymaps
				keymap("n", "<leader>cd", vim.diagnostic.open_float, vim.tbl_extend("force", opts, { desc = "Line Diagnostics" }))
				keymap("n", "]d", vim.diagnostic.goto_next, vim.tbl_extend("force", opts, { desc = "Next Diagnostic" }))
				keymap("n", "[d", vim.diagnostic.goto_prev, vim.tbl_extend("force", opts, { desc = "Prev Diagnostic" }))
				keymap("n", "<leader>cq", vim.diagnostic.setloclist, vim.tbl_extend("force", opts, { desc = "Quickfix Diagnostics" }))
			end

			-- Helper function to find git root
			local function find_git_root(start_path)
				local path = start_path
				while path ~= "/" and path ~= "" do
					if vim.fn.isdirectory(path .. "/.git") == 1 then
						return path
					end
					path = vim.fn.fnamemodify(path, ":h")
				end
				return start_path
			end

			-- Disable inlay hints globally
			vim.lsp.inlay_hint.enable(false)

			-- Create autocommands to start LSP servers
			local lsp_group = vim.api.nvim_create_augroup("LspStart", { clear = true })

			-- Start CSS Language Server
			vim.api.nvim_create_autocmd("FileType", {
				group = lsp_group,
				pattern = { "css", "scss", "less" },
				callback = function()
					vim.lsp.start({
						name = "cssls",
						cmd = { "vscode-css-language-server", "--stdio" },
						root_dir = vim.fn.getcwd(),
					})
				end,
			})

			-- Start Tailwind CSS Language Server
			vim.api.nvim_create_autocmd("FileType", {
				group = lsp_group,
				pattern = { "html", "css", "scss", "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
				callback = function()
					local root_dir = find_git_root(vim.fn.expand("%:p:h"))
					vim.lsp.start({
						name = "tailwindcss",
						cmd = { "tailwindcss-language-server", "--stdio" },
						root_dir = root_dir,
					})
				end,
			})

			-- Start TypeScript Language Server
			vim.api.nvim_create_autocmd("FileType", {
				group = lsp_group,
				pattern = { "javascript", "javascriptreact", "javascript.jsx", "typescript", "typescriptreact", "typescript.tsx" },
				callback = function()
					local root_dir = find_git_root(vim.fn.expand("%:p:h"))
					vim.lsp.start({
						name = "tsserver",
						cmd = { "typescript-language-server", "--stdio" },
						root_dir = root_dir,
						single_file_support = false,
						settings = {
							typescript = {
								inlayHints = {
									includeInlayParameterNameHints = "literal",
									includeInlayParameterNameHintsWhenArgumentMatchesName = false,
									includeInlayFunctionParameterTypeHints = true,
									includeInlayVariableTypeHints = false,
									includeInlayPropertyDeclarationTypeHints = true,
									includeInlayFunctionLikeReturnTypeHints = true,
									includeInlayEnumMemberValueHints = true,
								},
							},
							javascript = {
								inlayHints = {
									includeInlayParameterNameHints = "all",
									includeInlayParameterNameHintsWhenArgumentMatchesName = false,
									includeInlayFunctionParameterTypeHints = true,
									includeInlayVariableTypeHints = true,
									includeInlayPropertyDeclarationTypeHints = true,
									includeInlayFunctionLikeReturnTypeHints = true,
									includeInlayEnumMemberValueHints = true,
								},
							},
						},
						on_attach = setup_keymaps,
					})
				end,
			})

			-- Start HTML Language Server
			vim.api.nvim_create_autocmd("FileType", {
				group = lsp_group,
				pattern = { "html" },
				callback = function()
					vim.lsp.start({
						name = "html",
						cmd = { "vscode-html-language-server", "--stdio" },
						root_dir = vim.fn.getcwd(),
						on_attach = setup_keymaps,
					})
				end,
			})

			-- Start YAML Language Server
			vim.api.nvim_create_autocmd("FileType", {
				group = lsp_group,
				pattern = { "yaml", "yaml.docker-compose" },
				callback = function()
					vim.lsp.start({
						name = "yamlls",
						cmd = { "yaml-language-server", "--stdio" },
						root_dir = vim.fn.getcwd(),
						settings = {
							yaml = {
								keyOrdering = false,
							},
						},
						on_attach = setup_keymaps,
					})
				end,
			})

			-- Start Lua Language Server
			vim.api.nvim_create_autocmd("FileType", {
				group = lsp_group,
				pattern = { "lua" },
				callback = function()
					vim.lsp.start({
						name = "lua_ls",
						cmd = { "lua-language-server" },
						root_dir = vim.fn.getcwd(),
						single_file_support = true,
						settings = {
							Lua = {
								workspace = {
									checkThirdParty = false,
								},
								completion = {
									workspaceWord = true,
									callSnippet = "Both",
								},
								misc = {
									parameters = {},
								},
								hint = {
									enable = true,
									setType = false,
									paramType = true,
									paramName = "Disable",
									semicolon = "Disable",
									arrayIndex = "Disable",
								},
								doc = {
									privateName = { "^_" },
								},
								type = {
									castNumberToInteger = true,
								},
								diagnostics = {
									disable = { "incomplete-signature-doc", "trailing-space" },
									groupSeverity = {
										strong = "Warning",
										strict = "Warning",
									},
									groupFileStatus = {
										["ambiguity"] = "Opened",
										["await"] = "Opened",
										["codestyle"] = "None",
										["duplicate"] = "Opened",
										["global"] = "Opened",
										["luadoc"] = "Opened",
										["redefined"] = "Opened",
										["strict"] = "Opened",
										["strong"] = "Opened",
										["type-check"] = "Opened",
										["unbalanced"] = "Opened",
										["unused"] = "Opened",
									},
									unusedLocalExclude = { "_*" },
								},
								format = {
									enable = false,
									defaultConfig = {
										indent_style = "space",
										indent_size = "2",
										continuation_indent_size = "2",
									},
								},
							},
						},
						on_attach = setup_keymaps,
					})
				end,
			})
		end,
	},
}