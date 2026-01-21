# ybx_parent_client

优伴学家长端app，项目集成了

- tdesign flutter
- dio request 封装
- signals store 管理
- syslog 日志
- tools 工具函数
- widget 小部件
- 多环境运行 (dev, prod, mock)
- 路由管理
- claudecode集成

# cc mcp安装

[mcp](mcp.md)


# 关于tddesigner

ios需要安装cocoapods

- `brew install cocoapods`

# 一些常用工具函数，放在

lib/utils/tools.dart

[tools](lib/utils/tools.dart)

## 如何运行多环境

### 推荐通过debug方式运行（自动刷新）

见下图：

选择运行环境，点击调试按钮运行, 改代码会自动刷新

![debug](./scripts/imgs/debug.png)

然后点击 run-anyway

![run-anyway](./scripts/imgs/run-anyway.png)

- debug时，点击继续调试

![continue-debug](./scripts/imgs/debug-anyway.png)

debug模式的日志，点击下面的标签页查看

![debug-logs](./scripts/imgs/debug-logs.png)

### 手动运行，需要按 r进行刷新

首先项目根目录执行: `pnpm i`

- run mock

```bash
npm run dev:mock
```

会自动创建.env.mock.local 文件，内容如下

```md
# ====== mock，填写你本机的ip 地址 + 6009 ====
API_HOST = http://192.168.10.254:6009
ENV_NAME = mock
```

- run dev

```bash
npm run dev
```

- run prod

```bash
npm run dev:prod
```


## 构建

```bash
npm run build:apk

npm run build:ios
```
