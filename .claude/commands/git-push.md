# Git 提交推送命令

自动提交并推送当前改动，生成结构清晰的 commit message。

## 指令说明

你的任务是分析当前的 git 改动，并使用规范的 commit message 进行提交和推送。

### 第一步：拉取最新代码
执行 `git pull` 拉取远程最新代码。

**冲突检测**：
- 如果 pull 成功且没有冲突，继续下一步
- 如果出现合并冲突（输出包含 "CONFLICT" 或 "Merge conflict"），**立即停止所有后续操作**，并提醒用户：
  ```
  ⚠️  检测到合并冲突，无法自动提交推送。
  请手动解决冲突后再执行此命令。

  冲突文件：[列出冲突的文件]
  ```
- 如果 pull 失败（其他错误），也停止操作并告知用户

### 第二步：分析改动
并行运行以下命令：
- `git status` - 查看所有改动和未跟踪的文件
- `git diff HEAD` - 查看所有改动（已暂存和未暂存）

### 第三步：生成 Commit Message

基于改动内容，遵循以下规则创建 commit message：

**提交类型规则**（来自 commitlint.config.cjs）：
- `Feat` - 新功能或新特性
- `Fix` - Bug 修复
- `Update` - 更新现有功能
- `Refactor` - 代码重构
- `Style` - 代码格式调整（格式化等）
- `Doc` - 文档变更
- `Test` - 测试相关改动
- `Framework` - 框架/构建配置改动
- `Revert` - 回滚之前的改动

**消息格式**：
```
Type: 改动的简要总结

- 详细改动 1
- 详细改动 2
- 详细改动 3
...
```

**要求**：
1. 从上面的列表中选择最合适的类型
2. 第一行：简短总结（整体改了什么）
3. 空一行后：用列表列出每个重要改动
4. 每个细节单独一行，使用 `-` 前缀
5. 具体说明添加/修改/修复了什么
6. 根据项目上下文使用中文或英文
7. **不要添加** "Generated with [Claude Code]"、"Co-Authored-By: Claude" 等自动生成的信息

### 第四步：执行提交和推送

1. 暂存所有改动：`git add .`
2. 使用生成的 message 创建提交（使用 HEREDOC 格式）(如果commit过程报错，立即停止操作并提醒用户)
3. 推送到远程：`git push`

### 第五步：确认

推送后，显示：
- Commit hash 和 message
- 分支名称
- 推送状态

### 第六步：清理权限配置

推送成功后，自动清理 `.claude/settings.local.json` 中新增的 commit 权限：

1. 读取 `.claude/settings.local.json` 文件
2. 从 `permissions.allow` 数组中移除所有以 `Bash(git commit -m "$(cat <<''EOF''` 开头的具体 commit 权限
3. **保留** `Bash(git commit -m :*)` 通配符权限
4. 使用 Write 工具更新文件

**清理规则：**
- 只移除包含 HEREDOC 格式的具体 commit 命令
- 不要移除 `Bash(git commit -m :*)` 通配符
- 不要移除其他 git 相关权限（pull、add、push 等）

**重要：清理完成后，不要再提交 settings.local.json 文件的改动。此文件为本地配置，改动应保留在工作区。**

### 重要提示

- 如果 pull 时发现有冲突，立即中断操作并提醒用户
- 如果没有改动，不要推送
- 如果因为 commitlint 校验失败，调整 message 格式后重试
- 不要询问确认 - 直接分析并执行
