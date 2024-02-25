local keymap = vim.keymap

local options = {
	noremap = true,
	silent = true,
}

keymap.set("n", "x", '"_x', options)
keymap.set("n", "+", "<c-a>", options)
keymap.set("n", "-", "<c-x>", options)
keymap.set("n", "<c-a>", "gg<s-v>G", options)
keymap.set("n", "te", ":tabedit<return>", options)
keymap.set("n", "tc", ":tabclose<return>", options)
keymap.set("n", "<tab>", ":tabnext<return>", options)
keymap.set("n", "<s-tab>", ":tabprevious<return>", options)
keymap.set("n", "ss", ":split<return>", options)
keymap.set("n", "sv", ":vsplit<return>", options)
keymap.set("n", "<space>", "<c-w>w", options)
keymap.set("n", "sh", "<c-w>h", options)
keymap.set("n", "sj", "<c-w>j", options)
keymap.set("n", "sk", "<c-w>k", options)
keymap.set("n", "sl", "<c-w>l", options)
keymap.set("n", "<c-w><left>", "<c-w><", options)
keymap.set("n", "<c-w><down>", "<c-w>-", options)
keymap.set("n", "<c-w><up>", "<c-w>+", options)
keymap.set("n", "<c-w><right>", "<c-w>>", options)

keymap.set("v", "J", ":m'>+1<return>gv", options)
keymap.set("v", "K", ":m'<-2<return>gv", options)

keymap.set("v", ";uc", "gU", options)
keymap.set("v", ";lc", "gu", options)
keymap.set("v", ";st", ":sort i<return>", options)
keymap.set("v", ";dl", ":g/^$/d<return>:noh<return>", options)
keymap.set("v", ";nl", ":s/\\n/\\r\\r/g<return>:noh<return>", options)

keymap.set("n", "dj", function()
	vim.diagnostic.goto_next()
end, options)
keymap.set("n", "dk", function()
	vim.diagnostic.goto_prev()
end, options)
