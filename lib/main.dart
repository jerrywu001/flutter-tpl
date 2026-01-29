import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:ybx_parent_client/api/request/index.dart';
import 'package:ybx_parent_client/routes/routes.dart';
import 'package:ybx_parent_client/stores/index.dart';
import 'package:ybx_parent_client/utils/index.dart';

import 'pages/home/index.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 初始化 GetStorage
  await GetStorage.init();

  // 初始化 HTTP 请求
  HttpRequest.init();

  // 启用 TDesign 多主题功能
  TDTheme.needMultiTheme(true);

  // 初始化主题状态
  await themeStore.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 获取 TDesign 默认主题数据
    final themeData = TDTheme.defaultData();

    return Watch((context) {
      // 别删除，Fix安卓: signal 依赖被追踪（直接访问 themeMode）
      final _ = themeStore.themeMode.value;

      SystemLog.success(
        '🌗 System Theme Changed:  ${themeStore.flutterThemeMode.value}（${themeStore.themeMode.value}）',
      );

      return MaterialApp(
        title: 'Flutter Demo',
        // 浅色主题
        theme: themeData.systemThemeDataLight,
        // 深色主题
        darkTheme: themeData.systemThemeDataDark,
        // 主题模式（响应式）
        themeMode: themeStore.flutterThemeMode.value,
        initialRoute: AppRoutes.home,
        builder: (context, child) {
          // rpx适配
          SizeFit.initialize(context);
          return child ?? const SizedBox.shrink();
        },
        routes: {
          AppRoutes.home: (context) =>
              const MyHomePage(title: 'Flutter Demo Home Page'),
          ...AppRoutes.routes,
        },
      );
    });
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const MessageScreen(),
    const MineScreen(),
  ];

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _screens[_selectedIndex];
  }
}
