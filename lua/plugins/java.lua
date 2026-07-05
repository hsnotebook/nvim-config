-- 轻量 Java 阅读方案：平时靠 treesitter + ctags(:MakeTags) + telescope grep 看代码，
-- **不**自动启动 jdtls。需要补全 / 重命名 / 引用查找 / 诊断时，手动 :JdtStart 拉起 LSP；
-- 启动后本 session 内之后打开的 java 文件会自动 attach。
--
-- cmd 两个坑（详见 ~/.claude memory: nvim-jdtls-java21-vs-java8）：
-- 1) jdtls 要 Java 21+，但本项目按 CLAUDE.md 用 JAVA_HOME=java-8 构建 →
--    用 --java-executable 钉死 Java 21（jdtls.py 中优先级高于 JAVA_HOME）。
-- 2) 本机同时有 mason 的 jdtls 和系统 /usr/bin/jdtls(v1.58.0)，用绝对路径固定 mason 那份，
--    避免两版本写同一个 workspace 损坏 .metadata。
-- 注：必须显式带 lombok，否则 Lombok 注解（@Data 等）会失效。
return {
  {
    "mfussenegger/nvim-jdtls",
    opts = {
      cmd = {
        vim.fn.stdpath("data") .. "/mason/bin/jdtls",
        "--java-executable=/usr/lib/jvm/java-21-openjdk/bin/java",
        "--jvm-arg=-javaagent:" .. vim.fn.stdpath("data") .. "/mason/share/jdtls/lombok.jar",
      },
      root_dir = function(path)
        return vim.fs.root(path, { ".git" })
          or vim.fs.root(path, vim.lsp.config.jdtls.root_markers)
      end,
      project_name = function(root_dir)
        return root_dir and vim.fs.basename(root_dir)
      end,
      jdtls_config_dir = function(project_name)
        return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/config"
      end,
      jdtls_workspace_dir = function(project_name)
        return vim.fn.stdpath("cache") .. "/jdtls/" .. project_name .. "/workspace"
      end,
      full_cmd = function(opts)
        local fname = vim.api.nvim_buf_get_name(0)
        local root_dir = opts.root_dir(fname)
        local project_name = opts.project_name(root_dir)
        local cmd = vim.deepcopy(opts.cmd)
        if project_name then
          vim.list_extend(cmd, {
            "-configuration",
            opts.jdtls_config_dir(project_name),
            "-data",
            opts.jdtls_workspace_dir(project_name),
          })
        end
        return cmd
      end,
    },
    config = function(_, opts)
      local function capabilities()
        if LazyVim.has("blink.cmp") then
          return require("blink.cmp").get_lsp_capabilities()
        elseif LazyVim.has("cmp-nvim-lsp") then
          return require("cmp_nvim_lsp").default_capabilities()
        end
      end

      local function attach_jdtls()
        local fname = vim.api.nvim_buf_get_name(0)
        require("jdtls").start_or_attach({
          cmd = opts.full_cmd(opts),
          root_dir = opts.root_dir(fname),
          capabilities = capabilities(),
        })
      end

      -- 手动启动：首次 :JdtStart 启动当前 buffer，并对后续打开的 java 文件自动 attach
      local started = false
      vim.api.nvim_create_user_command("JdtStart", function()
        if not started then
          started = true
          vim.api.nvim_create_autocmd("FileType", {
            pattern = "java",
            callback = attach_jdtls,
          })
        end
        attach_jdtls()
        vim.notify("jdtls 已启动（手动模式）", vim.log.levels.INFO)
      end, { desc = "手动启动 jdtls（当前 buffer + 后续 java 文件）" })
    end,
  },
}
