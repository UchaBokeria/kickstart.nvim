# Using Neovim Configuration with VSCode

This guide explains the key differences between using our Neovim configuration standalone versus using it through the VSCode-Neovim extension.

## Setup Requirements

1. Install the [VSCode-Neovim](https://marketplace.visualstudio.com/items?itemName=asvetliakov.vscode-neovim) extension
2. Have Neovim (0.9.0+) installed on your system
3. Configure VSCode to use our Neovim configuration

## Key Differences

### 1. Plugin Behavior

Our configuration automatically detects VSCode and adjusts plugin loading. Here's a complete analysis of all plugins:

#### Enabled in Both Environments:
- `vim-visual-multi` - Multi-cursor support
- `nvim-autopairs` - Automatic bracket pairing

#### Disabled in VSCode (Native VSCode Features Used Instead):

**Theme/UI Related:**
- `tokyonight.nvim`, `evangelion.nvim`, `fluoromachine.nvim`
- `neofusion.nvim`, `poimandres.nvim`, `vesper.nvim`
- `nord.nvim`, `vim-cyberpunk`, `nightfox.nvim`, `kanagawa.nvim`
- `indent-blankline.nvim` - Indentation guides
- `todo-comments.nvim` - TODO highlighting
- `mini.nvim` - UI components

**File Navigation/Search:**
- `telescope.nvim` and its extensions:
  - `telescope-file-browser.nvim` - File browsing (use VSCode Explorer)
  - `telescope-fzf-native.nvim` - Fuzzy finding (use VSCode Quick Open)
  - `telescope-undo.nvim` - Undo history (use VSCode Timeline)
  - `telescope-project.nvim` - Project management (use VSCode Workspaces)
  - `telescope-zoxide` - Directory jumping (use VSCode Recent)
  - `telescope-bookmarks.nvim` - Browser bookmarks (N/A in VSCode)
  - `telescope-media-files.nvim` - Media preview (use VSCode Preview)
  - `telescope-repo.nvim` - Repository listing (use VSCode Source Control)
  - `telescope-heading.nvim` - Document symbols (use VSCode Outline)
  - `telescope-live-grep-args.nvim` - Advanced search (use VSCode Search)

**Advanced Telescope Features in Neovim:**
When using Neovim standalone, our telescope configuration provides powerful features:

1. **File Browser** (`<leader>fb`):
   - Navigate directories with vim-like keybindings
   - Create, delete, rename files
   - Toggle hidden files
   - Quick directory jumping

2. **Project Management** (`<leader>fp`):
   - Switch between projects
   - Recent projects history
   - Automatic workspace detection
   - Project-specific settings

3. **Advanced Search** (`<leader>fw`):
   - Live grep with arguments
   - Directory-specific search
   - Glob pattern support
   - Search in specific file types

4. **Git Integration**:
   - Worktree management (`<leader>gw`)
   - Repository listing (`<leader>fr`)
   - GitHub issues/PRs browser (`<leader>gh`)

5. **Document Navigation**:
   - Heading/symbol search (`<leader>fh`)
   - Undo tree visualization (`<leader>fu`)
   - Media files preview (`<leader>fm`)

6. **Custom Features**:
   - Browser bookmarks integration
   - Directory jumping with zoxide
   - Advanced file preview
   - Custom sorters and previewers

**Git Integration:**
- `gitsigns.nvim` - Git status in gutter
- `git-worktree.nvim` - Git worktree management
- `octo.nvim` - GitHub integration

**Language Support:**
- `go.nvim` - Go language support
- `guihua.lua` - UI library for Go tools
- `mason.nvim`, `mason-lspconfig.nvim`, `mason-tool-installer.nvim` - LSP management
- `mason-nvim-dap.nvim` - Debug adapter protocol
- `nvim-lspconfig` - LSP configuration
- `lazydev.nvim` - Lua development tools

**Debugging:**
- `nvim-dap` - Debug adapter protocol
- `nvim-dap-ui` - Debugging UI
- `nvim-dap-go` - Go debugging support
- `nvim-nio` - Async I/O

**Completion/Snippets:**
- `blink.cmp` - Completion engine
- `LuaSnip` - Snippet engine
- `friendly-snippets` - Snippet collection

**Utilities:**
- `startup.nvim` - Start screen
- `harpoon` - File navigation
- `nvim-notify` - Notification system
- `fidget.nvim` - LSP progress UI
- `which-key.nvim` - Keybinding helper
- `conform.nvim` - Code formatting
- `nvim-lint` - Linting engine

**Core Dependencies:**
- `plenary.nvim` - Lua functions library
- `nvim-web-devicons` - File icons
- `lazy.nvim` - Plugin manager

### 2. Keybindings

#### Common Keybindings (Work in Both):
```
<leader>w     - Select word with extra char
<leader>"     - Wrap selection in double quotes
<leader>'     - Wrap selection in single quotes
J (visual)    - Move selected lines down
K (visual)    - Move selected lines up
```

#### VSCode-Specific Keybindings:
```
<leader>f     - Quick Open (VSCode)
<leader>e     - Toggle Sidebar
<leader>b     - Toggle Activity Bar
<leader>p     - Show Commands Palette
```

#### Neovim-Only Keybindings:
```
<leader>pf    - Project Files (Telescope)
<C-p>         - Git Files
<leader>ps    - Project Search
<leader>tt    - Theme Switcher
<leader>aa    - Harpoon Add File
<leader>1-4   - Harpoon File Navigation
```

### 3. Features Comparison

| Feature | Standalone Neovim | VSCode-Neovim |
|---------|------------------|---------------|
| Themes | Custom theme system | Uses VSCode themes |
| File Search | Telescope | VSCode search |
| Git Integration | Custom plugins | VSCode Git features |
| Completion | nvim-cmp | VSCode IntelliSense |
| LSP | Built-in LSP | VSCode LSP |
| Terminal | Built-in terminal | VSCode integrated terminal |

## Best Practices

1. **Clipboard Usage**:
   - In VSCode: Use VSCode's clipboard commands (`cmd/ctrl+c`, `cmd/ctrl+v`)
   - In Neovim: Use registers (`"*y`, `"+y`)

2. **Search and Replace**:
   - VSCode: Prefer VSCode's search/replace for large operations
   - Neovim: Vim's search/replace works but may be slower for large files

3. **File Navigation**:
   - VSCode: Use VSCode's file explorer and quick open
   - Neovim: Use Telescope and custom file navigation

## Common Issues and Solutions

1. **Visual Block Mode**:
   - If visual block mode behaves unexpectedly, ensure you're using the latest version of VSCode-Neovim
   - Some operations might work better using VSCode's column selection (Shift+Alt)

2. **Performance**:
   - If experiencing lag, try disabling conflicting VSCode extensions
   - Ensure Neovim is properly installed and accessible in your PATH

3. **Keybinding Conflicts**:
   - Check for conflicts between VSCode and Neovim keybindings
   - Use VSCode's keybinding editor to resolve conflicts

## VSCode-Specific Configuration

Our configuration automatically detects VSCode and adjusts settings. The detection is done via:

```lua
vim.g.vscode = vim.g.vscode or 0  -- Default to 0 if not set
local is_vscode = vim.g.vscode == 1
```

### Custom Commands in VSCode

To execute VSCode commands from Neovim mode, use:

```lua
vim.cmd [[call VSCodeNotify('command.id')]]
```

Example:
```lua
-- Toggle sidebar
vim.keymap.set('n', '<leader>e', 
  "<Cmd>call VSCodeNotify('workbench.action.toggleSidebarVisibility')<CR>",
  { desc = 'Toggle Sidebar' }
)
```

## Recommended VSCode Extensions

When using VSCode-Neovim, these extensions complement our setup:

1. **Which Key**: For keybinding hints
2. **VSCode Icons**: For better file icons
3. **Git Lens**: For enhanced Git integration

## Switching Between Environments

Our configuration maintains consistency where possible while leveraging each environment's strengths. When switching:

1. **From Neovim to VSCode**:
   - Use VSCode's native features for file tree, search, and Git
   - Rely on VSCode's IntelliSense for completion
   - Use VSCode's terminal integration

2. **From VSCode to Neovim**:
   - Use Telescope for file navigation
   - Use built-in LSP features
   - Use custom theme system

## Contributing

If you find any issues or have suggestions for improving VSCode integration, please:

1. Check if the issue is related to VSCode-Neovim extension
2. Test in both environments to isolate the issue
3. Submit a detailed bug report or PR 