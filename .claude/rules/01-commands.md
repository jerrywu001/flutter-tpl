# 构建和开发命令

## NPM 脚本（推荐）

项目集成了 npm 脚本用于多环境运行，类似小程序开发模式：

```bash
# 开发环境运行（使用 .env.development）
npm run dev

# 生产环境运行（使用 .env.production）
npm run dev:prod

# 运行 mock 服务器
npm run dev:mock

# 构建 APK（生产环境）
npm run build:apk

# 构建 iOS（生产环境）
npm run build:ios

# 启动 mock 服务器
npm run server
```

## Flutter 命令

```bash
# 安装依赖
flutter pub get

# 运行应用（调试模式）
flutter run

# 在特定设备上运行应用
flutter run -d <device_id>

# 使用环境配置运行
flutter run --dart-define-from-file .env.development
flutter run --dart-define-from-file .env.production

# 构建发布版本
flutter build apk --dart-define-from-file .env.production --release
flutter build ios --dart-define-from-file .env.production --release
flutter build windows      # Windows

# 代码分析
flutter analyze

# 运行测试
flutter test

# 运行单个测试文件
flutter test test/widget_test.dart

# 格式化代码
dart format .
```
