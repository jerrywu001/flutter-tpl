import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:signals/signals_flutter.dart';

/// 主题模式枚举
enum AppThemeMode {
  /// 跟随系统
  system('system'),

  /// 浅色模式
  light('light'),

  /// 深色模式
  dark('dark');

  const AppThemeMode(this.value);
  final String value;

  static AppThemeMode fromValue(String value) {
    return AppThemeMode.values.firstWhere(
      (e) => e.value == value,
      orElse: () => AppThemeMode.system,
    );
  }
}

/// 主题状态管理
class ThemeStore {
  ThemeStore._();

  static final ThemeStore _instance = ThemeStore._();
  static ThemeStore get instance => _instance;

  /// GetStorage 实例
  final _storage = GetStorage();

  /// 存储键
  static const String _themeKey = 'theme_mode';

  /// 当前主题模式
  final themeMode = signal<AppThemeMode>(AppThemeMode.system);

  /// 获取 Flutter ThemeMode（计算属性）
  late final flutterThemeMode = computed(() {
    switch (themeMode.value) {
      case AppThemeMode.light:
        return ThemeMode.light;
      case AppThemeMode.dark:
        return ThemeMode.dark;
      case AppThemeMode.system:
        return ThemeMode.system;
    }
  });

  /// 初始化主题（从本地存储加载）
  Future<void> init() async {
    final savedTheme = _storage.read<String>(_themeKey);
    if (savedTheme != null) {
      themeMode.value = AppThemeMode.fromValue(savedTheme);
    }
  }

  /// 切换主题模式
  Future<void> setThemeMode(AppThemeMode mode) async {
    themeMode.value = mode;
    await _storage.write(_themeKey, mode.value);
  }

  /// 切换到浅色模式
  Future<void> setLightMode() async {
    await setThemeMode(AppThemeMode.light);
  }

  /// 切换到深色模式
  Future<void> setDarkMode() async {
    await setThemeMode(AppThemeMode.dark);
  }

  /// 跟随系统
  Future<void> setSystemMode() async {
    await setThemeMode(AppThemeMode.system);
  }
}

/// 全局主题状态实例
final themeStore = ThemeStore.instance;
