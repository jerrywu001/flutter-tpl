import 'package:signals/signals.dart';

/// 计数器状态管理
class CounterStore {
  CounterStore._();

  static final CounterStore _instance = CounterStore._();
  static CounterStore get instance => _instance;

  /// 计数器值
  final counter = signal(0);

  /// 计算属性：基于 counter 的派生值
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
