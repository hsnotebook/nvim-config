-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
-- Visual mode: Y to copy file path with line numbers to clipboard
vim.keymap.set("v", "Y", function()
  local file_path = vim.fn.expand("%:p")
  local start_line = vim.fn.line("v")
  local end_line = vim.fn.line(".")
  if start_line > end_line then
    start_line, end_line = end_line, start_line
  end
  local result = string.format("在 %s 的第 %d-%d 行：", file_path, start_line, end_line)
  vim.fn.setreg("+", result)
  vim.notify("Copied: " .. result)
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end, { desc = "Copy file path with line numbers" })

vim.keymap.del("n", "<leader>n")
vim.keymap.del({ "i", "n", "v" }, "<A-k>")
vim.keymap.del({ "i", "n", "v" }, "<A-j>")
vim.keymap.del({ "i", "n", "v" }, "<C-s>")
