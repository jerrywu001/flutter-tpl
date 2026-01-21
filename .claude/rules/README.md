# Claude Code 项目指南

此目录包含 Claude Code（claude.ai/code）在此存储库中工作时的指导文件。

## 文件说明

- `00-requirements.md` - 项目环境需求和依赖
- `01-commands.md` - 构建和开发命令
- `02-architecture.md` - 应用架构和项目结构
- `03-responsive-design.md` - 响应式设计系统
- `04-status-bar.md` - 状态栏样式管理
- `05-widgets.md` - 可复用组件
- `06-navigation.md` - 导航模式
- `07-code-style.md` - 代码风格和 Lint 规则
- `08-http-request.md` - HTTP 请求系统
- `09-environment.md` - 环境配置
- `10-state-management.md` - 状态管理
- `11-logging.md` - 日志工具
- `12-types.md` - 类型定义规范
- `13-tdesign.md` - TDesign UI 组件库使用指南

## 快速开始

1. 阅读 `00-requirements.md` 了解环境需求
2. 查看 `01-commands.md` 了解常用命令
3. 理解 `02-architecture.md` 中的应用架构
4. 参考其他文件处理特定功能

## 新增功能

项目最近新增了以下功能：

- **HTTP 请求系统**：基于 dio 的统一请求封装
- **环境配置**：支持多环境切换（开发/生产）
- **状态管理**：使用 signals 进行响应式状态管理
- **日志工具**：彩色日志输出和 JSON 格式化
- **Mock 服务器**：本地开发 mock 数据支持
