return {
	{
		"mfussenegger/nvim-dap",
		enabled = true,
		keys = {
			{
				";;d",
				"",
				desc = "Debug",
			},
			{
				";;dt",
				function()
					local dap = require("dap")
					dap.toggle_breakpoint()
				end,
				desc = "Toggle breakpoint",
			},
			{
				";;dc",
				function()
					local dap = require("dap")
					dap.continue()
				end,
				desc = "Continue",
			},
			{
				";;di",
				function()
					local dap = require("dap")
					dap.step_into()
				end,
				desc = "Step into",
			},
			{
				";;dj",
				function()
					local dap = require("dap")
					dap.down()
				end,
				desc = "Down",
			},
			{
				";;dk",
				function()
					local dap = require("dap")
					dap.up()
				end,
				desc = "Up",
			},
			{
				";;do",
				function()
					local dap = require("dap")
					dap.step_out()
				end,
				desc = "Step Out",
			},
			{
				";;dn",
				function()
					local dap = require("dap")
					dap.terminate()
				end,
				desc = "Terminate",
			},
			{
				";;dw",
				function()
					local widgets = require("dap.ui.widgets")
					widgets.hover()
				end,
				desc = "Widgets",
			},
		},
	},
}
