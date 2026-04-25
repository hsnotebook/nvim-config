# Git 提交信息格式

本项目使用 Angular 规范的 Git 提交信息格式。

## 格式

```
<type>(<scope>): <subject>
<BLANK LINE>
<body>
<BLANK LINE>
<footer>
```

## Type

| 类型       | 说明                                   |
|------------|----------------------------------------|
| feat       | 新功能                                 |
| fix        | 修复 bug                               |
| docs       | 文档更新                               |
| style      | 代码格式（不影响代码运行的变动）       |
| refactor   | 重构（既不是新增功能，也不是修复 bug） |
| perf       | 性能优化                               |
| test       | 增加测试                               |
| build      | 构建过程或辅助工具的变动               |
| ci         | CI 相关变动                            |
| chore      | 其他不修改 src 或 test 的变动          |
| revert     | 回滚到上一个版本                       |

## Scope（可选）

表示 commit 影响的范围，例如：
- 模块名
- 页面名
- 组件名

## Subject

- 简短描述，不超过 50 个字符
- 使用祈使句，现在时态
- 首字母小写
- 结尾不加句号

## Body（可选）

- 详细描述修改原因、修改内容
- 使用祈使句，现在时态

## Footer（可选）

- 不兼容变动（Breaking Changes）
- 关闭 Issue（如 `Closes #123`）

## 示例

```
feat(auth): 添加用户登录功能

实现基于 JWT 的用户认证系统，支持邮箱和密码登录。

Closes #45
```

```
fix(api): 修复用户列表分页错误

修复当 pageSize 为 0 时返回空列表的问题。

Closes #78
```
