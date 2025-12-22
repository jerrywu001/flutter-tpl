# 构建和开发命令

## 常用命令

```bash
# 安装依赖
flutter pub get

# 运行应用（调试模式）
flutter run

# 在特定设备上运行应用
flutter run -d <device_id>

# 构建发布版本
flutter build apk          # Android
flutter build ios          # iOS
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
