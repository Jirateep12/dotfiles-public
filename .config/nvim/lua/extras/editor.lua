return {
	{
		"smjonas/inc-rename.nvim",
		enabled = true,
		keys = {
			{
				";rn",
				function()
					return ":IncRename " .. vim.fn.expand("<cword>")
				end,
				expr = true,
				desc = "Rename the current word under the cursor",
			},
		},
	},
	{
		"ThePrimeagen/refactoring.nvim",
		enabled = true,
		keys = {
			{
				";rf",
				function()
					local refactoring = require("refactoring")
					refactoring.select_refactor()
				end,
				desc = "Refactor",
			},
		},
	},
	{
		"nvim-telescope/telescope.nvim",
		enabled = true,
		dependencies = {
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-telescope/telescope-file-browser.nvim",
		},
		keys = {
			{
				";f",
				":Telescope find_files<return>",
				desc = "Lists files in your current working directory, respects .gitignore",
			},
			{
				";l",
				":Telescope live_grep<return>",
				desc = "Lists files in your current working directory, respects .gitignore",
			},
			{
				"\\\\",
				":Telescope buffers<return>",
				desc = "Lists open buffers",
			},
			{
				";h",
				":Telescope help_tags<return>",
				desc = "Lists help tags",
			},
			{
				";d",
				":Telescope diagnostics<return>",
				desc = "Lists diagnostics",
			},
			{
				";t",
				":Telescope todo-comments<return>",
				desc = "Lists todo comments",
			},
			{
				"sf",
				function()
					local telescope = require("telescope")
					telescope.extensions.file_browser.file_browser({ path = "%:p:h", cwd = vim.fn.expand("%:p:h") })
				end,
				desc = "Open file browser with the path of the current buffer",
			},
		},
		opts = function(_, opts)
			local telescope = require("telescope")
			local actions = require("telescope.actions")
			local file_browser_actions = require("telescope").extensions.file_browser.actions
			opts.defaults = {
				prompt_prefix = " ",
				selection_caret = " ",
				sorting_strategy = "ascending",
				initial_mode = "normal",
			}
			opts.extensions = {
				find_files = {
					hidden = true,
				},
				live_grep = {
					additional_args = { "--hidden" },
				},
				file_browser = {
					grouped = true,
					hidden = true,
					previewer = false,
					mappings = {
						["n"] = {
							["n"] = file_browser_actions.create,
							["<c-u>"] = function(prompt_bufnr)
								for i = 1, 12 do
									actions.move_selection_previous(prompt_bufnr)
								end
							end,
							["<c-d>"] = function(prompt_bufnr)
								for i = 1, 12 do
									actions.move_selection_next(prompt_bufnr)
								end
							end,
						},
					},
				},
			}
			telescope.setup(opts)
			require("telescope").load_extension("fzf")
			require("telescope").load_extension("file_browser")
			require("telescope").load_extension("todo-comments")
		end,
	},
	{
		"kdheepak/lazygit.nvim",
		enabled = true,
		keys = {
			{
				";lg",
				":LazyGit<return>",
				desc = "Open lazygit",
			},
		},
	},
	{
		"andweeb/presence.nvim",
		enabled = true,
		opts = {
			neovim_image_text = "@jirateep12<contact@jirateep.com>",
			main_image = "file",
		},
	},
	{
		"mg979/vim-visual-multi",
		enabled = true,
	},
}
