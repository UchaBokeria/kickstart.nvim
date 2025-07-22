local map = vim.keymap.set

-- 📁 File browser
map('n', '<leader>fb', function()
  require('telescope').extensions.file_browser.file_browser { path = '%:p:h', initial_mode = 'normal' }
end, { desc = 'Telescope: File Browser' })

-- 🗂 Projects
map('n', '<leader>fp', function()
  require('telescope').extensions.project.project {}
end, { desc = 'Telescope: Projects' })

-- 🧠 Undo tree
map('n', '<leader>fu', function()
  require('telescope').extensions.undo.undo()
end, { desc = 'Telescope: Undo Tree' })

-- 🌲 Git Worktree
map('n', '<leader>fw', function()
  require('telescope').extensions.git_worktree.git_worktrees()
end, { desc = 'Telescope: Git Worktrees' })

-- 📂 Zoxide
map('n', '<leader>fz', function()
  require('telescope').extensions.zoxide.list()
end, { desc = 'Telescope: Zoxide' })

-- 🔖 Bookmarks
map('n', '<leader>bm', function()
  require('telescope').extensions.bookmarks.bookmarks()
end, { desc = 'Telescope: Browser Bookmarks' })

-- 🖼 Media files
map('n', '<leader>fm', function()
  require('telescope').extensions.media_files.media_files()
end, { desc = 'Telescope: Media Files' })

-- 🐙 GitHub PRs/issues
map('n', '<leader>gh', ':Octo<CR>', { desc = 'Octo: GitHub Interface' })

-- 📍 All Git repos
map('n', '<leader>fr', function()
  require('telescope').extensions.repo.list()
end, { desc = 'Telescope: Git Repos' })

-- 📄 Headings
map('n', '<leader>fh', function()
  require('telescope').extensions.heading.heading()
end, { desc = 'Telescope: Markdown/Org Headings' })
