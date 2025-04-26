return {
	{
		'nvim-lualine/lualine.nvim',
		dependencies = { 'nvim-tree/nvim-web-devicons' },
		config = function()
			local lualine = require('lualine')
			local webdevicons = require('nvim-web-devicons')

			local function filename()
				local devicons = require('nvim-web-devicons')
				local filename = vim.fn.expand('%:t')
				local ext = vim.fn.expand('%:e')
				if filename == '' then
					filename = 'No File Open'
				end
				local icon = devicons.get_icon(filename, ext, { default = true })
				return icon and (icon .. ' ' .. filename) or filename
			end

			local config = {
				options = {
					icons_enabled = true,
					component_separators = '',
					section_separators = '',
					disabled_filetypes = {
						statusline = {},
						winbar = {},
					},
					ignore_focus = {},
					always_divide_middle = true,
					always_show_tabline = true,
					globalstatus = false,
					refresh = {
						statusline = 100,
						tabline = 100,
						winbar = 100,
					}
				},
				sections = {
					lualine_a = {
						{
							function() return "󰊠" end,
							'mode',
							separator = { left = ' ', right = '' },
						}
					},
					lualine_b = {
						{
							'branch',
							icon = '󰊢', 
							separator = { right = '' },
						},
						{
							'diff',
							symbols = { added = ' ', modified = ' ', removed = ' ' },
							separator = { right = '' },
						},
						{
							'diagnostics',
							symbols = { error = '󰅘 ', warn = '󰳤 ', info = '󰰃 ', hint = '󰏭 ' },
							separator = { right = '' },
						},
					},
					lualine_c = { { filename } },
					lualine_x = { 'encoding', 'fileformat' },
					lualine_y = {},
					lualine_z = {
						{
							'location',
							separator = { left = ' ', right = ' ' },
						}
					},
				},
				inactive_sections = {
					lualine_a = {},
					lualine_b = {},
					lualine_c = {},
					lualine_x = {},
					lualine_y = {},
					lualine_z = {}
				},
				tabline = {},
				winbar = {},
				inactive_winbar = {},
				extensions = {}
			}
			lualine.setup(config)
		end,
	},
}
