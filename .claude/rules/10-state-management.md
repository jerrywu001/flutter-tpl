# 状态管理

## 概述

项目使用 `signals` 包进行响应式状态管理，提供简洁的 API 和自动依赖追踪。

## 文件结构

```
lib/stores/
├── index.dart                # 导出文件
└── home/
    └── counter_demo.dart     # 计数器状态管理示例
```

## 核心概念

### Signal

响应式状态值，当值改变时自动通知依赖的组件重新构建。

```dart
final counter = signal(0);
```

### Computed

基于其他 signal 的派生值，自动追踪依赖并在依赖变化时重新计算。

```dart
late final fullName = computed(
  () => 'counter updated by global store: ${counter.value}',
);
```

## Store 模式

使用单例模式创建全局状态管理：

```dart
class CounterStore {
  CounterStore._();

  static final CounterStore _instance = CounterStore._();
  static CounterStore get instance => _instance;

  /// 计数器值
  final counter = signal(0);

  /// 计算属性
  late final fullName = computed(
    () => 'counter updated by global store: ${counter.value}',
  );

  /// 增加计数
  void increment() {
    counter.value++;
  }

  /// 减少计数
  void decrement() {
    if (counter.value > 0) {
      counter.value--;
    }
  }

  /// 重置计数
  void reset() {
    counter.value = 0;
  }
}

/// 全局单例
final counterStore = CounterStore.instance;
```

## 在组件中使用

### 读取状态

使用 `Watch` 小部件自动监听状态变化：

```dart
import 'package:signals/signals_flutter.dart';
import 'package:ybx_parent_client/stores/index.dart';

class MyWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Watch((context) {
      return Text('Count: ${counterStore.counter.value}');
    });
  }
}
```

### 更新状态

直接调用 store 的方法：

```dart
ElevatedButton(
  onPressed: () => counterStore.increment(),
  child: Text('Increment'),
)
```

### 使用计算属性

```dart
Watch((context) {
  return Text(counterStore.fullName.value);
})
```

## 完整示例

```dart
import 'package:flutter/material.dart';
import 'package:signals/signals_flutter.dart';
import 'package:ybx_parent_client/stores/index.dart';

class CounterPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Watch((context) {
              return Text(
                '${counterStore.counter.value}',
                style: Theme.of(context).textTheme.headlineMedium,
              );
            }),
            SizedBox(height: 20),
            Watch((context) {
              return Text(counterStore.fullName.value);
            }),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => counterStore.decrement(),
                  child: Text('-'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => counterStore.increment(),
                  child: Text('+'),
                ),
                SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => counterStore.reset(),
                  child: Text('Reset'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

## 最佳实践

1. **使用单例模式**：为每个功能模块创建独立的 Store 单例
2. **分离业务逻辑**：将状态管理逻辑与 UI 组件分离
3. **使用 computed**：对于派生状态使用 computed 而不是手动计算
4. **最小化 Watch 范围**：只在需要响应状态变化的最小组件上使用 Watch
5. **命名规范**：Store 类以 `Store` 结尾，全局实例使用小驼峰命名

## 与其他状态管理方案对比

| 特性 | Signals | Provider | Riverpod | Bloc |
|------|---------|----------|----------|------|
| 学习曲线 | 低 | 中 | 中 | 高 |
| 样板代码 | 少 | 中 | 中 | 多 |
| 性能 | 高 | 中 | 高 | 高 |
| 自动依赖追踪 | ✓ | ✗ | ✓ | ✗ |

## 注意事项

1. 在 `Watch` 内部访问 signal 的 `.value` 才会建立依赖关系
2. 避免在 `Watch` 外部直接修改 signal 值
3. 对于复杂的异步操作，考虑使用 `effect` 或 `batch`
4. Store 应该是无状态的单例，所有状态都通过 signal 管理
