return {
    {
        'startup-nvim/startup.nvim',
        dependencies = { 'nvim-telescope/telescope.nvim', 'nvim-lua/plenary.nvim', 'nvim-telescope/telescope-file-browser.nvim' },
        config = function()
          require('startup').setup { theme = 'startify' }
        end,
    },
    { 'mg979/vim-visual-multi' },
    {
        'rcarriga/nvim-notify',
        config = function()
          vim.notify = require 'notify'
        end,
    },
    {
        'ThePrimeagen/harpoon',
        branch = 'harpoon2',
        dependencies = { 'nvim-lua/plenary.nvim' },
    },
}