return {
	{
		"Exafunction/codeium.vim",
		enabled = false,
		config = function()
			vim.g.codeium_disable_bindings = 1
			vim.g.codeium_filetypes = {
				["*"] = true,
			}
			vim.keymap.set("i", "<c-a>", function()
				return vim.fn["codeium#Accept"]()
			end, { expr = true })
			vim.keymap.set("i", "]]", function()
				return vim.fn["codeium#CycleCompletions"](1)
			end, { expr = true })
			vim.keymap.set("i", "[[", function()
				return vim.fn["codeium#CycleCompletions"](-1)
			end, { expr = true })
		end,
	},
	{
		"zbirenbaum/copilot.lua",
		enabled = false,
		opts = {
			suggestion = {
				enabled = true,
				auto_trigger = true,
				keymap = {
					accept = "<c-a>",
					next = "]]",
					prev = "[[",
				},
			},
			filetypes = {
				["*"] = true,
			},
		},
	},
}
