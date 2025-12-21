# Figma MCP 服务配置

本目录包含 MCP (Model Context Protocol) 服务器配置，用于集成 Figma Desktop。

## 配置说明

### Figma Desktop MCP 服务

配置文件：`mcp.json`

该配置连接到本地运行的 Figma Desktop MCP 服务器（`http://127.0.0.1:3845/mcp`）。

## 前置要求

1. **安装 Figma Desktop 应用**
   - 确保已安装最新版本的 Figma Desktop 应用
   - Figma Desktop 需要处于运行状态

2. **启用 MCP 服务**
   - 在 Figma Desktop 中启用 MCP 服务器功能
   - 默认端口为 3845

## 使用方式

### 在 Claude Code 中使用

如果你使用的是 Claude Code CLI，该配置会自动被识别。

### 验证配置

1. 确保 Figma Desktop 正在运行
2. 检查 MCP 服务是否已启动（通常在 Figma Desktop 的设置中）
3. 使用以下命令测试连接：

```bash
curl http://127.0.0.1:3845/mcp
```

## 配置

- Claude 配置

> claude必须手动添加figma-desktop服务，如下：

```bash
claude mcp add --transport http figma-desktop http://127.0.0.1:3845/mcp
```
具体文档：

https://developers.figma.com/docs/figma-mcp-server/local-server-installation/#claude-code

- cursor配置

https://developers.figma.com/docs/figma-mcp-server/remote-server-installation/#cursor

## 功能特性

通过 Figma MCP 服务，可以：

- 访问 Figma 设计文件
- 读取设计组件和样式
- 导出设计资源
- 与 Figma API 交互

## 故障排除

### 连接失败

如果无法连接到 MCP 服务，请检查：

1. Figma Desktop 是否正在运行
2. MCP 服务是否已在 Figma Desktop 中启用
3. 端口 3845 是否被占用
4. 防火墙设置是否允许本地连接

### 端口冲突

如果默认端口 3845 被占用，需要：

1. 在 Figma Desktop 中更改 MCP 服务端口
2. 更新 `mcp.json` 中的 URL 配置

## 更多信息

- [Model Context Protocol 文档](https://modelcontextprotocol.io/)
- [Figma API 文档](https://www.figma.com/developers/api)
