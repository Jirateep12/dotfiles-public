return {
	{
		"neovim/nvim-lspconfig",
		enabled = true,
		opts = {
			inlay_hints = {
				enabled = true,
			},
			setup = {
				clangd = function(_, opts)
					opts.capabilities.offsetEncoding = { "utf-16" }
				end,
				eslint = function()
					local util = require("lazyvim.util")
					util.lsp.on_attach(function(client)
						if client.name == "eslint" then
							client.server_capabilities.documentFormattingProvider = true
						elseif client.name == "tsserver" then
							client.server_capabilities.documentFormattingProvider = false
						end
					end)
				end,
			},
		},
	},
}
