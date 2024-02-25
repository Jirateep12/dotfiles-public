return {
	{
		"nvim-neotest/neotest",
		enabled = true,
		dependencies = {
			"nvim-neotest/neotest-jest",
		},
		keys = {
			{
				";;t",
				"",
				desc = "Test",
			},
			{
				";;tf",
				function()
					local neotest = require("neotest")
					neotest.run.run(vim.fn.expand("%"))
				end,
				desc = "Run tests in current file",
			},
			{
				";;ta",
				function()
					local neotest = require("neotest")
					neotest.run.run(vim.loop.cwd())
				end,
				desc = "Run all tests",
			},
			{
				";;to",
				function()
					local neotest = require("neotest")
					neotest.output_panel.toggle()
				end,
				desc = "Toggle output panel",
			},
			{
				";;ts",
				function()
					local neotest = require("neotest")
					neotest.run.stop()
				end,
				desc = "Stop running tests",
			},
		},
		opts = {
			adapters = {
				["neotest-jest"] = {
					jestConfigFile = function()
						local file = vim.fn.expand("%:p")
						local config_file
						local extensions = { "js", "mjs" }
						local function find_config(base_dir)
							for _, extension in ipairs(extensions) do
								local config_path = base_dir .. "jest.config." .. extension
								if vim.fn.filereadable(config_path) == 1 then
									return config_path
								end
							end
						end
						if string.find(file, "/packages/") then
							local base_dir = string.match(file, "(.-/[^/]+/)src")
							config_file = find_config(base_dir)
						else
							local cwd = vim.fn.getcwd()
							config_file = find_config(cwd .. "/")
						end
						return config_file
					end,
					cwd = function()
						local file = vim.fn.expand("%:p")
						if string.find(file, "/packages/") then
							return string.match(file, "(.-/[^/]+/)src")
						end
						return vim.fn.getcwd()
					end,
				},
			},
		},
	},
}
