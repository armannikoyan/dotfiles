return {
	{
		"VonHeikemen/lsp-zero.nvim",
		dependencies = {
			-- LSP Support
			{ "neovim/nvim-lspconfig" },
			{ "williamboman/mason.nvim" },
			{ "williamboman/mason-lspconfig.nvim" },

			-- Autocompletion
			{ "hrsh7th/nvim-cmp" },
			{ "hrsh7th/cmp-buffer" },
			{ "hrsh7th/cmp-path" },
			{ "saadparwaiz1/cmp_luasnip" },
			{ "hrsh7th/cmp-nvim-lsp" },
			{ "hrsh7th/cmp-nvim-lua" },

			-- Snippets
			{ "L3MON4D3/LuaSnip" },
			{ "rafamadriz/friendly-snippets" },
		},
		config = function()
			local lsp_zero = require('lsp-zero')

			lsp_zero.setup({
				ensure_installed = { 'clangd', 'lua_ls', 'rust_analyzer' },
			})

			lsp_zero.on_attach(function(client, bufnr)
				lsp_zero.default_keymaps({buffer = bufnr})
			end)

			lsp_zero.set_sign_icons({
				error = ' ',
				warn = ' ',
				hint = ' ',
				info = ' '
			})

			require("mason").setup({
				ui = {
					icons = {
						package_installed = "",
						package_pending = "➜",
						package_uninstalled = ""
					}
				}
			})

			require('mason-lspconfig').setup({
				ensure_installed = { 'clangd', 'lua_ls', 'rust_analyzer' },
				automatic_installation = false,
				handlers = {
					-- Default handler
					lsp_zero.default_setup,

          lsp_zero.configure('lua_ls', {
            cmd = { 'lua-language-server' },
            settings = {
              Lua = {
                runtime = {
                  version = 'LuaJIT',
                  path = vim.split(package.path, ';'),
                },
                diagnostics = {
                  globals = { 'vim' },
                },
              },
            },
          })
				},
			})

			local cmp = require('cmp')
			local cmp_action = require('lsp-zero').cmp_action()

			cmp.setup({
				mapping = cmp.mapping.preset.insert({
					['<CR>'] = cmp.mapping.confirm({select = false}),
					['<C-f>'] = cmp_action.luasnip_jump_forward(),
					['<C-b>'] = cmp_action.luasnip_jump_backward(),
					['<C-u>'] = cmp.mapping.scroll_docs(-4),
					['<C-d>'] = cmp.mapping.scroll_docs(4),
				}),
				sources = {
					{ name = 'nvim_lsp' },
					{ name = 'buffer' },
					{ name = 'path' },
					{ name = 'luasnip' },
				}
			})
		end,
	},
}

