vim.keymap.set('n', '<leader>ct', '<Cmd>CopilotChatToggle<CR>', { desc = 'Toggle CopilotChat' })

vim.g.copilot_no_tab_map = true
vim.keymap.set('i', '<S-Tab>', 'copilot#Accept("\\<S-Tab>")', { expr = true, replace_keycodes = false })

return {
  {
    'github/copilot.vim',
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'nvim-lua/plenary.nvim', branch = 'master' },
    },
    build = 'make tiktoken',
    opts = {
      model = 'gpt-5.2',
    },
  },
}

-- vim: ts=2 sts=2 sw=2 et
