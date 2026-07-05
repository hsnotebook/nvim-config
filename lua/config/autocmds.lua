-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
local function augroup(name)
  return vim.api.nvim_create_augroup("hs_" .. name, { clear = true })
end

vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
  group = augroup("txt"),
  pattern = { "*.txt" },
  callback = function()
    vim.bo.filetype = "markdown"
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("java"),
  pattern = { "java" },
  callback = function(args)
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4

    -- gd: 与 LSP 同键跳定义。:JdtStart 启动 LSP 后 LazyVim 会用 LSP 版本覆盖此 buffer-local 映射；
    -- 未启动时 fallback 到 ctags。回退统一用 Ctrl-o（ctags/LSP 跳转都进 jumplist）。
    vim.keymap.set("n", "gd", function()
      -- 双保险：若已有支持 definition 的 LSP client，仍走 LSP
      for _, client in ipairs(vim.lsp.get_clients({ bufnr = args.buf })) do
        if client.supports_method("textDocument/definition") then
          return vim.lsp.buf.definition()
        end
      end
      local word = vim.fn.expand("<cword>")
      local tags = vim.fn.taglist("^" .. word .. "$")
      if vim.tbl_isempty(tags) then
        if vim.tbl_isempty(vim.fn.taglist(word)) then
          return vim.notify(
            "ctags 无 " .. word .. " 的索引，跑 :MakeTags 或 :JdtStart",
            vim.log.levels.WARN
          )
        end
        tags = vim.fn.taglist(word)
      end
      if #tags == 1 then
        vim.cmd("tag " .. word)
        return
      end
      -- 多匹配：用 snacks.picker 展示（与 LSP picker 同款，带源码预览）；失败回退 :tselect
      local ok = pcall(function()
        Snacks.picker({
          title = "ctags: " .. word,
          items = vim.tbl_map(function(t)
            return {
              text = (t.signature or t.name) .. "  [" .. (t.kind or "?") .. "]",
              file = t.filename,
              pos = t.ln and { t.ln, 1 } or nil,
              tag = t,
            }
          end, tags),
          preview = "file",
          confirm = function(picker, item)
            picker:close()
            vim.cmd("edit " .. vim.fn.fnameescape(item.tag.filename))
            pcall(vim.cmd, item.tag.cmd)
          end,
        })
      end)
      if not ok then
        vim.cmd("tselect " .. word)
      end
    end, { buffer = args.buf, desc = "跳定义（LSP 优先，否则 ctags）" })
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  group = augroup("markdown"),
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.tabstop = 4
    vim.opt_local.shiftwidth = 4
  end,
})

-- `vim.opt.spell = false` in options.lua does not work.
-- So use autocmds to config `spell`
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("spell"),
  pattern = { "markdown", "gitcommit" },
  callback = function()
    vim.opt_local.spell = false
  end,
})

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

-- ============================================================
-- ctags 轻量代码导航（看代码用，替代 LSP 做跳转）
-- 依赖系统 universal-ctags：sudo pacman -S universal-ctags
-- 用法：Ctrl-] 跳定义 / Ctrl-t 回退 / :tag Name / :ts 选择同名符号
-- tags 在项目根，neovim 默认 'tags' 会向上递归查找，子目录打开文件也能命中。
-- ============================================================
local function project_root(bufnr)
  return vim.fs.root(bufnr or 0, {
    ".git",
    "build.gradle",
    "build.gradle.kts",
    "pom.xml",
    "settings.gradle",
  })
end

local function gen_ctags(root, on_done)
  vim.system({
    "ctags",
    "-R",
    "--languages=Java",
    "--fields=+Sn",
    "--exclude=target",
    "--exclude=build",
    "--exclude=.git",
    "--exclude=node_modules",
    ".",
  }, { cwd = root }, function(obj)
    vim.schedule(function()
      if on_done then
        on_done(obj.code == 0, obj.stderr)
      end
    end)
  end)
end

vim.api.nvim_create_user_command("MakeTags", function()
  if vim.fn.executable("ctags") == 0 then
    return vim.notify("未找到 ctags，请安装：sudo pacman -S universal-ctags", vim.log.levels.ERROR)
  end
  local root = project_root()
  if not root then
    return vim.notify("未找到项目根（.git / pom.xml / build.gradle）", vim.log.levels.WARN)
  end
  vim.notify("生成 ctags 索引：" .. root, vim.log.levels.INFO)
  gen_ctags(root, function(ok, err)
    vim.notify(
      ok and "ctags 完成，Ctrl-] 可用" or ("ctags 失败：" .. (err or "")),
      ok and vim.log.levels.INFO or vim.log.levels.ERROR
    )
  end)
end, { desc = "在项目根生成 ctags 索引" })

-- 首次进入 Java 项目、且项目根尚无 tags 时自动后台生成一次
local ctags_done = {}
vim.api.nvim_create_autocmd("FileType", {
  group = augroup("ctags"),
  pattern = "java",
  callback = function(args)
    if vim.fn.executable("ctags") == 0 then
      return
    end
    local root = project_root(args.buf)
    if not root or ctags_done[root] then
      return
    end
    ctags_done[root] = true
    if vim.fn.filereadable(root .. "/tags") == 1 then
      return
    end
    vim.notify("后台生成 ctags 索引…", vim.log.levels.INFO)
    gen_ctags(root, function(ok)
      vim.notify(ok and "ctags 就绪" or "ctags 生成失败", vim.log.levels.INFO)
    end)
  end,
})
