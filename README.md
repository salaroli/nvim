# nvim

Configuração pessoal do Neovim usando [`lazy.nvim`](https://github.com/folke/lazy.nvim) como gerenciador de plugins. Voltada para **desenvolvimento web (frontend)**, **embedded systems** (C/C++/Rust) e **scripting Linux** (bash, lua, python).

---

## Visão geral

| Categoria | Plugin |
|---|---|
| Plugin manager | `lazy.nvim` |
| Tema | `tokyonight` (variant `night`) |
| Statusline | `lualine` (tema `tokyonight`) |
| Fuzzy finder | `telescope.nvim` + `fzf-native` |
| File explorer | `neo-tree.nvim` |
| Sintaxe | `nvim-treesitter` (branch `main`) |
| LSP | `nvim-lspconfig` + `mason.nvim` + `mason-lspconfig` |
| Completion | `blink.cmp` v1 |
| Formatter | `conform.nvim` |
| Rust | `rustaceanvim` (gerencia `rust-analyzer` + DAP) |
| Git | `gitsigns.nvim` |
| Outros | `which-key`, `Comment.nvim`, `nvim-autopairs` |

---

## Pré-requisitos do sistema

A maioria dos LSPs/formatters/linters é instalada via Mason **dentro do Neovim**, mas o Mason precisa de runtimes do sistema para compilar/baixar os pacotes.

### Obrigatórios

| Item | Para quê |
|---|---|
| **Neovim ≥ 0.12** | nvim-treesitter `main` exige 0.12+ |
| **git** | clonar plugins |
| **C compiler** (`gcc` ou `clang`) | compilar parsers do treesitter |
| **make** | build do `telescope-fzf-native` |
| **`tree-sitter` CLI** | nvim-treesitter `main` usa o CLI oficial pra compilar parsers |
| **Node.js** | alguns grammars do treesitter geram código via `node` antes de compilar |
| **unzip** + **curl** ou **wget** | Mason baixa pacotes |
| **Nerd Font** no terminal | ícones do `web-devicons`, `lualine`, `neo-tree` |

### Para os atalhos de busca do Telescope

| Item | Para quê |
|---|---|
| **`ripgrep`** | `:Telescope live_grep` (Ctrl+Shift+F) |
| **`fd`** | `:Telescope find_files` mais rápido (Ctrl+P) |

### Runtimes para Mason instalar LSPs

| Runtime | LSPs / tools que dependem |
|---|---|
| **Node.js + npm** | `ts_ls`, `eslint`, `html`, `cssls`, `tailwindcss`, `vue_ls`, `jsonls`, `dockerls`, `yamlls`, `marksman`, `prettier`, `prettierd` |
| **Python 3 + pip** | `pyright` (na verdade Node, mas pip ajuda), formatadores Python (ruff já vem standalone) |
| **Rust + cargo** (`rustup`) | `rust-analyzer` (gerenciado pelo `rustaceanvim`); ideal ter para projetos Rust |

### Opcionais

| Item | Para quê |
|---|---|
| **clangd** (sistema) | C/C++ LSP — Mason baixa, mas a versão do sistema costuma ser melhor para projetos com `compile_commands.json` |
| **lldb** | debug C/C++/Rust (rustaceanvim usa `codelldb` via Mason) |
| **`arduino-cli`** (sistema) | obrigatório para o `arduino-language-server` funcionar — o Mason instala o servidor mas não o CLI |

### Para Arduino (arquivos `.ino`)

O `arduino-language-server` é instalado automaticamente pelo Mason, mas depende de dois binários do **sistema**:

- `arduino-cli` — gerencia cores, bibliotecas e gera o `compile_commands.json` que o LSP usa
- `clangd` — já instalado pelo Mason

**Instalação do `arduino-cli`:**

| Plataforma | Comando |
|---|---|
| Arch Linux | `yay -S arduino-cli` (AUR) |
| Ubuntu / Debian | ver bloco abaixo |
| Fedora | ver bloco abaixo |
| macOS | `brew install arduino-cli` |

Ubuntu / Debian e Fedora (sem pacote oficial no gerenciador):

```bash
curl -fsSL https://raw.githubusercontent.com/arduino/arduino-cli/master/install.sh | sh -s -- --bindir ~/.local/bin
```

**Pós-instalação (qualquer plataforma):**

```bash
arduino-cli config init
arduino-cli core update-index

# Instale o core da sua placa — exemplos:
arduino-cli core install arduino:avr        # Uno, Nano, Mega
arduino-cli core install arduino:megaavr    # Nano Every
arduino-cli core install arduino:mbed_nano  # Nano 33 IoT / BLE
arduino-cli core install esp32:esp32        # ESP32
```

> **Board padrão (`-fqbn`):** a config usa `arduino:avr:uno` por padrão. Para trocar para outro board, edite a linha `-fqbn` em `lua/plugins/lspconfig.lua`.

---

## Instalação por plataforma

### Arch Linux

```bash
sudo pacman -S \
  neovim git base-devel \
  tree-sitter-cli \
  ripgrep fd \
  nodejs npm \
  python python-pip \
  rustup \
  unzip wget
```

Para Rust:
```bash
rustup default stable
```

> **Atenção Python 3.14**: o Arch já entrega Python 3.14, e alguns LSPs (ex: `cmake-language-server`) ainda exigem `<3.14`. Se precisar deles, instale uma versão mais antiga via [`pyenv`](https://github.com/pyenv/pyenv):
> ```bash
> curl https://pyenv.run | bash
> # Para fish:
> echo 'set -gx PYENV_ROOT $HOME/.pyenv
> fish_add_path $PYENV_ROOT/bin
> pyenv init - fish | source' >> ~/.config/fish/config.fish
> pyenv install 3.13
> pyenv global 3.13
> ```

### Ubuntu / Debian

```bash
# Neovim ≥ 0.11 não está no apt antes do Ubuntu 24.04 — usar PPA
sudo add-apt-repository ppa:neovim-ppa/unstable
sudo apt update

sudo apt install -y \
  neovim git build-essential \
  ripgrep fd-find \
  python3-pip python3-venv \
  unzip curl

# fd em Debian/Ubuntu se chama fd-find — alias para fd:
mkdir -p ~/.local/bin
ln -s "$(which fdfind)" ~/.local/bin/fd

# Node LTS (mais novo que o do apt) — também usado pelo treesitter
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
sudo apt install -y nodejs

# tree-sitter CLI (não está no apt) — via npm:
sudo npm install -g tree-sitter-cli

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

### Fedora

```bash
sudo dnf install -y \
  neovim git gcc make \
  ripgrep fd-find \
  nodejs npm \
  python3 python3-pip \
  unzip wget

# tree-sitter CLI (Fedora não tem pacote oficial) — via npm:
sudo npm install -g tree-sitter-cli

# Rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

### openSUSE Tumbleweed

```bash
sudo zypper install -y \
  neovim git gcc make \
  ripgrep fd \
  nodejs npm \
  python3 python3-pip \
  unzip curl

# tree-sitter CLI via npm:
sudo npm install -g tree-sitter-cli

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```

### macOS (Homebrew)

```bash
# Homebrew, se ainda não tiver:
# /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew install \
  neovim git \
  tree-sitter \
  ripgrep fd \
  node \
  python \
  rustup-init

rustup-init -y
```

> **Compilador no macOS**: `xcode-select --install` instala `clang` + `make` (necessários para treesitter).
>
> O Homebrew chama o pacote do CLI de `tree-sitter` (sem `-cli`). Confirma com `which tree-sitter` — tem que retornar um caminho.

### Windows (WSL recomendado)

Use WSL com Ubuntu e siga as instruções de Ubuntu acima. Configuração nativa em Windows é possível mas frágil — Mason, treesitter e clangd preferem ambiente Unix.

---

## Nerd Font

Os ícones precisam de uma Nerd Font ativa no terminal.

### Instalação rápida

| OS | Comando |
|---|---|
| Arch | `sudo pacman -S ttf-jetbrains-mono-nerd` |
| Ubuntu/Debian | baixar manualmente em [nerdfonts.com](https://www.nerdfonts.com/font-downloads) e descompactar em `~/.local/share/fonts && fc-cache -fv` |
| Fedora | `sudo dnf install jetbrains-mono-fonts-all` (não é Nerd; pegar Nerd em [nerdfonts.com](https://www.nerdfonts.com)) |
| macOS | `brew install --cask font-jetbrains-mono-nerd-font` |

Depois, configure o terminal (alacritty, kitty, wezterm, ghostty, iTerm2, Konsole…) para usar a fonte Nerd. Em VSCode/Windows Terminal o procedimento é parecido.

---

## Instalação da config

```bash
# Backup do que já existir
mv ~/.config/nvim ~/.config/nvim.bak 2>/dev/null

git clone <URL-DESTE-REPO> ~/.config/nvim

nvim
```

Na primeira execução:

1. `lazy.nvim` se auto-instala em `~/.local/share/nvim/lazy/`
2. Todos os plugins são clonados
3. Mason começa a instalar LSPs/formatters/linters em background
4. Treesitter compila os parsers básicos (lua, vim, vimdoc, query) via o CLI `tree-sitter`; os demais são instalados sob demanda quando você abre um arquivo do filetype correspondente

Comandos úteis depois:

```vim
:Lazy            " ver status dos plugins
:Mason           " gerenciar LSPs/formatters
:MasonLog        " ver erros de instalação
:checkhealth     " diagnóstico geral
:checkhealth mason   " confirma que runtimes (node, python, etc.) estão OK
:TSUpdate        " atualizar parsers
```

---

## Atalhos principais

Leader = **Espaço**.

### Globais (estilo VSCode)

| Atalho | Ação |
|---|---|
| `Ctrl+P` | Quick open (find files) |
| `Ctrl+Shift+P` | Command palette |
| `Ctrl+Shift+F` | Find in files (grep) |
| `Ctrl+Shift+O` | Símbolos do arquivo |
| `Ctrl+T` | Símbolos do workspace |
| `Ctrl+B` | Toggle sidebar (neo-tree) |
| `Ctrl+Shift+E` | Focar explorer |
| `Ctrl+/` | Comentar linha |
| `Shift+Alt+A` | Comentar bloco |
| `Alt+↑ / ↓` | Mover linha |
| `Shift+Alt+↑ / ↓` | Duplicar linha |
| `Ctrl+A` | Selecionar tudo |
| `Ctrl+G` | Ir para linha (`:`) |
| `F8` / `Shift+F8` | Próximo / anterior diagnóstico |

### LSP (em buffers com servidor ativo)

| Atalho | Ação |
|---|---|
| `F12` | Go to definition |
| `Shift+F12` | Find references |
| `Ctrl+F12` | Go to implementation |
| `F2` | Renomear símbolo |
| `Ctrl+.` | Code action / quick fix |
| `K` ou `Ctrl+H` | Hover |

### Estilo Leader (vim-like)

| Atalho | Ação |
|---|---|
| `<leader>ff` | Find files |
| `<leader>fg` | Live grep |
| `<leader>fb` | Buffers |
| `<leader>fr` | Recentes |
| `<leader>fd` | Diagnostics |
| `<leader>e` | Toggle neo-tree |
| `<leader>ca` | Code action |
| `<leader>rn` | Rename |
| `<leader>cf` | Format |
| `<leader>gp/gs/gr/gb` | Git: preview/stage/reset/blame |
| `<leader>?` | which-key |

### Rust (rustaceanvim)

| Atalho | Ação |
|---|---|
| `<leader>rr` | Runnables |
| `<leader>rt` | Testables |
| `<leader>rd` | Debuggables |
| `<leader>rm` | Expand macro |
| `<leader>rc` | Abrir Cargo.toml |
| `<leader>re` | Explain error |
| `F5` | Start debugging |

---

## Estrutura

```
.
├── init.lua
└── lua/
    ├── config/
    │   ├── lazy.lua          # bootstrap do lazy.nvim
    │   ├── options.lua       # opções globais + leader
    │   ├── keymaps.lua       # atalhos globais
    │   └── autocmds.lua      # autocomandos
    └── plugins/              # 1 arquivo por plugin
        ├── colorscheme.lua
        ├── lualine.lua
        ├── web-devicons.lua
        ├── which-key.lua
        ├── telescope.lua
        ├── neo-tree.lua
        ├── treesitter.lua
        ├── autopairs.lua
        ├── comment.lua
        ├── mason.lua
        ├── lspconfig.lua
        ├── blink-cmp.lua
        ├── conform.lua
        ├── rustaceanvim.lua
        └── gitsigns.lua
```

Para adicionar um novo plugin: crie `lua/plugins/<nome>.lua` retornando uma spec do `lazy.nvim`. O `import = "plugins"` em `config/lazy.lua` carrega automaticamente.

---

## Troubleshooting

### Arduino LSP não inicia (`arduino-language-server` travado)

Causas comuns e soluções:

- **`arduino-cli` não encontrado no PATH** → instale conforme a seção [Para Arduino](#para-arduino-arquivos-ino) e confirme com `which arduino-cli`
- **Core da placa não instalado** → rode `arduino-cli core install arduino:avr` (ou o core da sua placa)
- **`-cli-config` não existe** → rode `arduino-cli config init` para gerar o arquivo de configuração
- **Board errado** → edite `-fqbn` em `lua/plugins/lspconfig.lua`; para listar boards instalados: `arduino-cli board listall`
- **Ver log do LSP** → `:LspLog` dentro do nvim

### Mason: "failed to install <X>"

Roda `:MasonLog` para ver o erro real. Causas comuns:

- **`failed to install ts_ls/eslint/html/...`** → falta `node` + `npm`
- **`failed to install cmake-language-server`** → falta `python` + `pip`, ou Python ≥ 3.14 (LSP exige `<3.14`)
- **`failed to install <pacote pip>`** → falta `python-virtualenv` em alguns sistemas
- **`Tool requires npm`** → o Mason não achou `npm` no PATH

### Treesitter: "Error during tarball extraction" / "not in gzip format"

Rate limit do GitHub ou rede. Tenta:

```vim
:TSInstall! <linguagem>   " força reinstalação
:TSUpdate                 " atualiza todos
```

### Treesitter: `ENOENT: ... 'tree-sitter'`

Falta o CLI `tree-sitter` no PATH. Veja a tabela de pré-requisitos — instale via gerenciador (`brew install tree-sitter`, `pacman -S tree-sitter-cli`) ou `npm install -g tree-sitter-cli`. Reabra o nvim depois.

### Treesitter: "attempt to call method 'range' (a nil value)"

Acontecia com o branch legado `master` (arquivado). A config já está no branch `main`. Se ainda ver isso, é parser velho do `master` em cache — resolve com:

```bash
rm -rf ~/.local/share/nvim/lazy/nvim-treesitter/parser
```

E depois `:TSUpdate` no nvim.

### Treesitter: `Query error ... Invalid field name`

Mismatch entre query nova e parser velho. Mesmo fix do item acima: apaga `~/.local/share/nvim/lazy/nvim-treesitter/parser` e roda `:TSUpdate`.

### `Ctrl+/` não comenta

Alguns terminais mandam `Ctrl+_` em vez de `Ctrl+/`. O config já mapeia os dois — se nem assim funcionar, é o terminal não enviando o keycode. Use `gcc` (vim-style) como alternativa.

### Ícones aparecem como caixinhas (`□`)

Falta Nerd Font ativa no terminal. Veja a seção [Nerd Font](#nerd-font).

---

## Notas

- **`rust_analyzer` não está em `mason.lua` nem em `lspconfig.lua`** — é gerenciado pelo `rustaceanvim`, que evita duplo attach.
- **`automatic_enable` do mason-lspconfig v2** está ativo por default, então não há `vim.lsp.enable()` manual.
- **Treesitter está no `branch = "main"`** (rewrite). O branch legado `master` foi arquivado em abr/2026 e quebra em Neovim 0.12 (`attempt to call method 'range' ...`). Não há `configs.setup{}` no `main` — highlight/indent são ligados via autocmd `FileType` em `lua/plugins/treesitter.lua`. Parsers são compilados pelo CLI `tree-sitter` (requisito novo).
- **`format_on_save`** está ativo (1s timeout). Para desativar pontualmente: `:noautocmd w`.
- **Arduino LSP (`arduino_language_server`)** usa `-fqbn arduino:avr:uno` como board padrão. Mude em `lua/plugins/lspconfig.lua` conforme a placa do projeto. O `arduino-cli` precisa estar no PATH do sistema; o Mason instala apenas o servidor em si.
