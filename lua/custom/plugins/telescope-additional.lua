return {
  {
    'nvim-telescope/telescope.nvim',
    dependencies = {
      -- 🔍 File Browser
      { 'nvim-telescope/telescope-file-browser.nvim' },

      -- ⚡ FZF-native sorter
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },

      -- 🧠 Undo tree
      { 'debugloop/telescope-undo.nvim' },

      -- 🗂 Project switching
      { 'nvim-telescope/telescope-project.nvim' },

      -- 🌲 Git worktree switcher
      { 'ThePrimeagen/git-worktree.nvim' },

      -- 📂 Zoxide integration
      { 'jvgrootveld/telescope-zoxide' },

      -- 🔖 Bookmarks
      { 'dhruvmanila/telescope-bookmarks.nvim' },

      -- 🖼 Media files (images, pdfs)
      { 'nvim-telescope/telescope-media-files.nvim' },

      -- 🐙 GitHub issues and PRs
      { 'pwntester/octo.nvim', dependencies = { 'nvim-lua/plenary.nvim' }, config = true },

      -- 📍 Git repo listing
      { 'cljoly/telescope-repo.nvim' },

      -- 📄 Markdown/Org heading search
      { 'crispgm/telescope-heading.nvim' },
    },

    config = function()
      local telescope = require 'telescope'
      telescope.setup {
        extensions = {
          file_browser = {
            hijack_netrw = true,
            grouped = true,
            hidden = true,
            previewer = false,
            initial_mode = 'normal',
            layout_config = { height = 40 },
          },
          project = {
            base_dirs = (function()
              local handle = io.popen "fd . --type d --hidden --exclude .git -E node_modules -d 3 -x test -e .git -E .git | sed 's|/.git||' | sort -u"
              if not handle then
                return {}
              end
              local result = {}
              for line in handle:lines() do
                table.insert(result, line)
              end
              handle:close()
              return result
            end)(),
            hidden_files = true,
            order_by = 'recent',
            theme = 'dropdown',
          },
          media_files = {
            filetypes = { 'png', 'webp', 'jpg', 'jpeg', 'pdf' },
            find_cmd = 'rg',
          },
        },
      }

      -- Load all extensions
      local exts = {
        'file_browser',
        'fzf',
        'undo',
        'project',
        'git_worktree',
        'zoxide',
        'bookmarks',
        'media_files',
        'gh', -- via octo.nvim
        'repo',
        'heading',
      }
      for _, ext in ipairs(exts) do
        pcall(telescope.load_extension, ext)
      end
    end,
  },
}
