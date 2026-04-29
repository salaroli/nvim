local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Limpar highlight de busca" })

map("n", "<C-h>", "<C-w>h", { desc = "Janela esquerda" })
map("n", "<C-j>", "<C-w>j", { desc = "Janela abaixo" })
map("n", "<C-k>", "<C-w>k", { desc = "Janela acima" })
map("n", "<C-l>", "<C-w>l", { desc = "Janela direita" })

map("n", "<leader>w", "<cmd>w<CR>", { desc = "Salvar arquivo" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Fechar janela" })

map("v", "<", "<gv", { desc = "Indentar esquerda" })
map("v", ">", ">gv", { desc = "Indentar direita" })

map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Mover seleção para baixo" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Mover seleção para cima" })
