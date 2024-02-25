vim.api.nvim_create_autocmd("InsertLeave", {
	pattern = "*",
	command = "set nopaste",
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.wrap = false
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = { "json", "jsonc", "json5", "markdown" },
	callback = function()
		vim.opt.conceallevel = 0
	end,
})
