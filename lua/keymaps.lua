vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })
vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")
vim.keymap.set('x', '<leader>p', [["_dP]]) -- paste WON'T copy
vim.keymap.set('n', '<leader>w', '<C-w>')
vim.keymap.set('n', '<leader><Tab>', '<cmd>bnext<cr>')

vim.keymap.set('n', '<leader>rp', ':%s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>') -- Replace all instance of current word in file
vim.keymap.set('v', '<leader>rp', ':s/\\<<C-r><C-w>\\>/<C-r><C-w>/gI<Left><Left><Left>') -- Replace all instance of current word in file

vim.keymap.set('n', '<leader>up', '<cmd>set paste!<cr>', { desc = 'Toggle Paste' })
vim.keymap.set('n', '<leader>ul', '<cmd>setlocal spell!<cr>', { desc = 'Toggle Spell' })
vim.keymap.set("n", '<leader>ug', '<cmd>LazyGit<cr>', { desc = 'Git' })

-- vim.keymap.set('n', 'Q', '<nop>')
vim.keymap.set('n', 'Q', '@q')
