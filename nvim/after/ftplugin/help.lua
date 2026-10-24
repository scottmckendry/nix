-- Open help as a full-height vertical split on the left instead of the
-- default horizontal split.
vim.cmd("wincmd H")
vim.cmd("vertical resize 80")

vim.wo.winfixwidth = true
vim.wo.wrap = true

vim.b.undo_ftplugin = (vim.b.undo_ftplugin or "") .. "\nsetlocal nowinfixwidth< nowrap<"
