return {
	{
		"nvim-neo-tree/neo-tree.nvim",
		enabled = false,
	},
	{
		"folke/flash.nvim",
		enabled = false,
	},
	{
		"lewis6991/gitsigns.nvim",
		enabled = true,
		opts = {
			on_attach = function(buffer)
				local gitsigns = package.loaded.gitsigns
				local function map(mode, l, r, desc)
					vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
				end
				map("n", "gj", gitsigns.next_hunk, "Next hunk")
				map("n", "gk", gitsigns.prev_hunk, "Prev hunk")
				map("n", "gd", gitsigns.diffthis, "Diff this")
			end,
		},
	},
	{
		"folke/todo-comments.nvim",
		enabled = true,
		keys = {
			{
				"tj",
				function()
					local todo_comments = require("todo-comments")
					todo_comments.jump_next()
				end,
				desc = "Jump to the next todo comment",
			},
			{
				"tk",
				function()
					local todo_comments = require("todo-comments")
					todo_comments.jump_prev()
				end,
				desc = "Jump to the previous todo comment",
			},
			{
				"td",
				function()
					local todo_comments = require("todo-comments")
					todo_comments.jump_next({ "FIX", "FIXME", "BUG", "WARN" })
				end,
				desc = "Jump to the next todo comment with a specific keyword",
			},
		},
	},
}
