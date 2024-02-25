return {
	{
		"echasnovski/mini.animate",
		enabled = true,
		opts = {
			scroll = {
				enable = false,
			},
			open = {
				enable = false,
			},
			close = {
				enable = false,
			},
		},
	},
	{
		"b0o/incline.nvim",
		enabled = true,
		dependencies = { "craftzdog/solarized-osaka.nvim" },
		opts = function(_, opts)
			opts.window = {
				padding = 0,
				margin = { horizontal = 0 },
			}
			opts.render = function(props)
				local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
				local icon, color = require("nvim-web-devicons").get_icon_color(filename)
				local helpers = require("incline.helpers")
				local modified = vim.bo[props.buf].modified
				return {
					icon and { " ", icon, " ", guibg = color, guifg = helpers.contrast_color(color) }
						or (filename ~= "" and { " ", "[+]" } or { " ", "[+]", " " }),
					filename ~= "" and { " ", filename, " ", gui = modified and "bold, italic" or "bold" } or "",
					guibg = icon,
				}
			end
		end,
	},
}
