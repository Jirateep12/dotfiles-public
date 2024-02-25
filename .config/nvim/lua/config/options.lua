vim.opt.encoding = "utf-8"
vim.opt.fileencoding = "utf-8"

vim.opt.title = true
vim.opt.showcmd = true
vim.opt.cmdheight = 0
vim.opt.hlsearch = true
vim.opt.inccommand = "split"
vim.opt.splitkeep = "cursor"

vim.opt.autoindent = true
vim.opt.smarttab = true
vim.opt.breakindent = true
vim.opt.backspace = { "start", "eol", "indent" }
vim.opt.formatoptions:append({ "r" })

vim.opt.shada = ""

vim.opt.backup = false

vim.opt.path:append({ "**" })
vim.opt.wildignore:append({ "*/node_modules/*" })
