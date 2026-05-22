return {
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    keys = {
      { "<cr>", "vap|<Plug>(DBUI_ExecuteQuery)", ft = "mysql" },
      { "<cr>", "<Plug>(DBUI_ExecuteQuery)", mode = "v", ft = "mysql" },
      { "<leader>db", "<cmd>TabooOpen DB<cr><cmd>DBUI<cr>", desc = "Open DBUI in new tab" },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      -- Your DBUI configuration
      vim.g.db_ui_use_nerd_fonts = 1
      vim.g.db_ui_execute_on_save = 0
    end,
  },
  {
    "saghen/blink.cmp",
    dependencies = { "kristijanhusak/vim-dadbod-completion" },
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      opts.sources.default = opts.sources.default or {}
      if not vim.tbl_contains(opts.sources.default, "dadbod") then
        table.insert(opts.sources.default, "dadbod")
      end
      opts.sources.providers = opts.sources.providers or {}
      opts.sources.providers.dadbod = {
        name = "Dadbod",
        module = "vim_dadbod_completion.blink",
      }
    end,
  },
}
