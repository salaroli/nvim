local map = vim.keymap.set

map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Limpar highlight de busca" })

map("n", "<C-h>", "<C-w>h", { desc = "Janela esquerda" })
map("n", "<C-j>", "<C-w>j", { desc = "Janela abaixo" })
map("n", "<C-k>", "<C-w>k", { desc = "Janela acima" })
map("n", "<C-l>", "<C-w>l", { desc = "Janela direita" })

map("n", "<leader>w", "<cmd>w<CR>", { desc = "Salvar arquivo" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Fechar janela" })

map("n", "<leader>|", "<cmd>vsplit<CR>", { desc = "Split vertical" })
map("n", "<leader>-", "<cmd>split<CR>", { desc = "Split horizontal" })

map("v", "<", "<gv", { desc = "Indentar esquerda" })
map("v", ">", ">gv", { desc = "Indentar direita" })

map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Mover seleção para baixo" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Mover seleção para cima" })

-- =========================================================================
-- Atalhos estilo VSCode
-- =========================================================================

-- Ctrl+G: Ir para linha
map("n", "<C-g>", ":", { desc = "Linha de comando (ir para linha)" })

-- Alt+Up / Alt+Down: Mover linha (modo normal e insert)
map("n", "<A-Down>", "<cmd>m .+1<CR>==", { desc = "Mover linha para baixo" })
map("n", "<A-Up>", "<cmd>m .-2<CR>==", { desc = "Mover linha para cima" })
map("i", "<A-Down>", "<Esc><cmd>m .+1<CR>==gi", { desc = "Mover linha para baixo" })
map("i", "<A-Up>", "<Esc><cmd>m .-2<CR>==gi", { desc = "Mover linha para cima" })
map("v", "<A-Down>", ":m '>+1<CR>gv=gv", { desc = "Mover seleção para baixo" })
map("v", "<A-Up>", ":m '<-2<CR>gv=gv", { desc = "Mover seleção para cima" })

-- Shift+Alt+Up / Shift+Alt+Down: Duplicar linha
map("n", "<S-A-Down>", "<cmd>t.<CR>", { desc = "Duplicar linha para baixo" })
map("n", "<S-A-Up>", "<cmd>t.-1<CR>", { desc = "Duplicar linha para cima" })
map("i", "<S-A-Down>", "<Esc><cmd>t.<CR>gi", { desc = "Duplicar linha para baixo" })
map("i", "<S-A-Up>", "<Esc><cmd>t.-1<CR>gi", { desc = "Duplicar linha para cima" })
map("v", "<S-A-Down>", ":t '><CR>gv=gv", { desc = "Duplicar seleção para baixo" })
map("v", "<S-A-Up>", ":t '<-1<CR>gv=gv", { desc = "Duplicar seleção para cima" })

-- Ctrl+A: Selecionar tudo
map({ "n", "v", "i" }, "<C-a>", "<Esc>ggVG", { desc = "Selecionar tudo" })

-- Ctrl+Z: Undo (insert mode também)
map("i", "<C-z>", "<C-o>u", { desc = "Undo" })

-- F8 / Shift+F8: Próximo / anterior diagnóstico
map("n", "<F8>", function() vim.diagnostic.jump({ count = 1, float = true }) end, { desc = "Próximo problema" })
map("n", "<S-F8>", function() vim.diagnostic.jump({ count = -1, float = true }) end, { desc = "Problema anterior" })
