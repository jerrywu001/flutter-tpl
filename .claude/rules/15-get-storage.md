# GetStorage 使用说明

## 为什么使用 GetStorage 替代 SharedPreferences？

### 问题背景

在使用 `shared_preferences` 时遇到了 Kotlin 编译错误：
```
Daemon compilation failed: null
java.lang.Exception
```

这是因为 `shared_preferences` 依赖原生平台代码（Android/iOS），在某些环境下会遇到：
- Kotlin 版本冲突
- Gradle 编译问题
- 原生依赖下载失败

### GetStorage 的优势

1. **纯 Dart 实现** - 不需要原生代码，避免编译问题
2. **更快的性能** - 直接写入内存，异步持久化到磁盘
3. **更简单的 API** - 同步读写，无需 async/await
4. **更小的体积** - 无原生依赖，包体积更小
5. **跨平台一致** - 所有平台行为完全一致

## 性能对比

| 特性 | GetStorage | SharedPreferences |
|------|-----------|-------------------|
| 实现方式 | 纯 Dart | 原生平台代码 |
| 读取速度 | 极快（内存） | 较慢（需要平台通道） |
| 写入速度 | 极快（异步持久化） | 较慢（同步写入） |
| 编译问题 | 无 | 可能有 Kotlin/Swift 问题 |
| 包体积 | 小 | 较大（包含原生代码） |

## 基本使用

### 1. 初始化

```dart
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化 GetStorage
  await GetStorage.init();

  runApp(const MyApp());
}
```

### 2. 读写数据

```dart
final storage = GetStorage();

// 写入数据
await storage.write('key', 'value');
storage.write('count', 42);
storage.write('user', {'name': 'John', 'age': 30});

// 读取数据
final value = storage.read('key');
final count = storage.read<int>('count');
final user = storage.read<Map>('user');

// 删除数据
await storage.remove('key');

// 清空所有数据
await storage.erase();

// 检查键是否存在
final hasKey = storage.hasData('key');
```

### 3. 监听变化

```dart
// 监听特定键的变化
storage.listenKey('theme_mode', (value) {
  print('Theme changed to: $value');
});

// 监听所有变化
storage.listen(() {
  print('Storage changed');
});
```

## 在项目中的使用

### 主题存储示例

```dart
class ThemeStore {
  final _storage = GetStorage();
  static const String _themeKey = 'theme_mode';

  // 保存主题
  Future<void> setThemeMode(AppThemeMode mode) async {
    await _storage.write(_themeKey, mode.value);
  }

  // 读取主题
  AppThemeMode getThemeMode() {
    final value = _storage.read<String>(_themeKey);
    return value != null
        ? AppThemeMode.fromValue(value)
        : AppThemeMode.system;
  }
}
```

## 高级功能

### 1. 使用容器（Container）

可以创建多个独立的存储容器：

```dart
// 默认容器
final storage = GetStorage();

// 自定义容器
final userStorage = GetStorage('user_data');
final settingsStorage = GetStorage('settings');

// 初始化自定义容器
await GetStorage.init('user_data');
await GetStorage.init('settings');
```

### 2. 加密存储

虽然 GetStorage 本身不提供加密，但可以结合加密库使用：

```dart
import 'package:encrypt/encrypt.dart';

class SecureStorage {
  final _storage = GetStorage();
  final _encrypter = Encrypter(AES(Key.fromLength(32)));
  final _iv = IV.fromLength(16);

  Future<void> writeSecure(String key, String value) async {
    final encrypted = _encrypter.encrypt(value, iv: _iv);
    await _storage.write(key, encrypted.base64);
  }

  String? readSecure(String key) {
    final encrypted = _storage.read<String>(key);
    if (encrypted == null) return null;
    return _encrypter.decrypt64(encrypted, iv: _iv);
  }
}
```

### 3. 默认值

```dart
// 读取时提供默认值
final theme = storage.read('theme_mode') ?? 'system';
final count = storage.read<int>('count') ?? 0;
```

## 迁移指南

### 从 SharedPreferences 迁移

```dart
// 旧代码（SharedPreferences）
final prefs = await SharedPreferences.getInstance();
await prefs.setString('key', 'value');
final value = prefs.getString('key');

// 新代码（GetStorage）
final storage = GetStorage();
await storage.write('key', 'value');
final value = storage.read('key');
```

主要区别：
1. 不需要 `getInstance()`
2. 读取是同步的（但仍然很快）
3. 写入可以是同步或异步

## 注意事项

1. **初始化**：必须在使用前调用 `GetStorage.init()`
2. **类型安全**：使用泛型指定读取的类型 `storage.read<int>('count')`
3. **持久化**：数据会自动持久化到磁盘，无需手动保存
4. **容器名称**：不同容器的数据是隔离的
5. **数据大小**：适合存储小量数据（配置、设置等），不适合大文件

## 性能优化

```dart
// 批量写入
await storage.write('key1', 'value1');
await storage.write('key2', 'value2');
await storage.write('key3', 'value3');

// 更好的方式：使用 Map
await storage.write('data', {
  'key1': 'value1',
  'key2': 'value2',
  'key3': 'value3',
});
```

## 调试

```dart
// 打印所有存储的数据
print(storage.getKeys());
print(storage.getValues());

// 获取存储文件路径
print(storage.path);
```

## 参考资料

- [GetStorage 官方文档](https://pub.dev/packages/get_storage)
- [GetStorage GitHub](https://github.com/jonataslaw/get_storage)
- [性能基准测试](https://github.com/jonataslaw/get_storage#-performance)
