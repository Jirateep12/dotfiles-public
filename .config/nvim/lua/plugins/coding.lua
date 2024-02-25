return {
	{
		"hrsh7th/nvim-cmp",
		enabled = true,
		dependencies = {
			"hrsh7th/cmp-emoji",
		},
		opts = function(_, opts)
			local cmp = require("cmp")
			opts.mapping = cmp.mapping.preset.insert({
				["<tab>"] = cmp.mapping.confirm({ select = true }),
			})
			table.insert(opts.sources, { name = "emoji" })
		end,
	},
}
