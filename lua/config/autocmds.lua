-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
local function augroup(name)
  return vim.api.nvim_create_augroup("hs_" .. name, { clear = true })
end

-- SSH 环境下发送输入法切换信号
local function send_input_method_signal(event)
  local ssh_client_ip = os.getenv("SSH_CONNECTION"):gmatch("%S+")()
  local cmd = string.format("echo '%s' | nc %s 12345", event, ssh_client_ip)
  vim.fn.jobstart({ "sh", "-c", cmd }, { detach = true })
end

local is_ssh = os.getenv("SSH_CONNECTION") ~= nil

if is_ssh then
  vim.api.nvim_create_autocmd("InsertLeave", {
    pattern = "*",
    callback = function()
      send_input_method_signal("INSERT_LEAVE")
    end,
  })

  vim.api.nvim_create_autocmd("InsertEnter", {
    pattern = "*",
    callback = function()
      send_input_method_signal("INSERT_ENTER")
    end,
  })
end
