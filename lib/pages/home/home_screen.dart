// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:ybx_parent_client/api/home/index.dart';
import 'package:ybx_parent_client/routes/routes.dart';
import 'package:ybx_parent_client/stores/index.dart';
import 'package:ybx_parent_client/types/home/index.dart';
import 'package:ybx_parent_client/utils/index.dart';
import 'package:ybx_parent_client/widgets/bottom_nav.dart';
import 'package:ybx_parent_client/widgets/image_uploader.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SignalsMixin {
  late final computedFullName = createComputed(
    () => 'counter updated by createComputed: ${counterStore.counter.value}',
  );

  Future<void> fetchNearbyCompanions() async {
    try {
      final result = await queryNearbyCompanions(
        QueryNearbyCompanionsParam(page: 1, size: 10),
      );

      if (result.list.isNotEmpty) {
        for (final item in result.list) {
          SystemLog.info('用户ID: ${item.userId}');
        }
      }
    } catch (e) {
      SystemLog.error(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    fetchNearbyCompanions();
  }

  @override
  Widget build(BuildContext context) {
    final String moneyStr = formatMoneyString('111221112');

    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('首页')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const TDButton(
              text: 'disabled button',
              size: TDButtonSize.small,
              type: TDButtonType.fill,
              shape: TDButtonShape.round,
              theme: TDButtonTheme.primary,
              disabled: true,
            ),
            const SizedBox(height: 10),
            Text('金额格式化(tools.dart)：$moneyStr '),
            const SizedBox(height: 10),
            TDButton(
              text: '点击查询接口',
              size: TDButtonSize.small,
              type: TDButtonType.fill,
              shape: TDButtonShape.round,
              theme: TDButtonTheme.primary,
              onTap: () async {
                TDToast.showLoading(context: context);

                await fetchNearbyCompanions();

                TDToast.dismissLoading();

                TDToast.showText('接口日志见控制台的日志', context: context);
              },
            ),
            const SizedBox(height: 10),
            const Text('下面展示了store在视图中的几种使用方式：'),
            const SizedBox(height: 10),
            TDButton(
              text: 'add counter',
              size: TDButtonSize.small,
              type: TDButtonType.fill,
              shape: TDButtonShape.round,
              theme: TDButtonTheme.primary,
              onTap: () {
                counterStore.increment();
              },
            ),
            const SizedBox(height: 10),
            Text(computedFullName.value),
            // 来自 Store 的 computed
            Watch((context) => Text(counterStore.fullName.value)),
            // 使用 Watch 监听 原始 signal 变化
            Watch(
              (context) => Text(
                'counter updated by Watch: ${counterStore.counter.value}',
              ),
            ),
            const SizedBox(height: 50),
            const Text('下面展示了图片上传组件的使用方式：'),
            const SizedBox(height: 10),
            ImageUploader(
              max: 2,
              multiple: true,
              wrapAlignment: WrapAlignment.center,
              onUploadSuccess: (file, url) {
                TDToast.showText('上传成功(数据看控制台日志', context: context);
              },
              onUploadError: (file, message) {
                TDToast.showText('上传失败: $message', context: context);
              },
            ),
            const SizedBox(height: 20),
            const Text('路由跳转测试'),
            const SizedBox(height: 20),
            TDButton(
              text: 'Go to Data List Demo',
              size: TDButtonSize.small,
              type: TDButtonType.fill,
              shape: TDButtonShape.round,
              theme: TDButtonTheme.defaultTheme,
              onTap: () {
                Navigator.pushNamed(context, AppRoutes.detail);
              },
            ),
            const SizedBox(height: 50),
            const Text('主题切换测试'),
            const SizedBox(height: 10),
            Watch((context) {
              final currentMode = themeStore.themeMode.value;
              return Column(
                children: [
                  Text(
                    '当前主题: ${_getThemeModeName(currentMode)}',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TDButton(
                        text: '浅色',
                        size: TDButtonSize.small,
                        type: currentMode == AppThemeMode.light
                            ? TDButtonType.fill
                            : TDButtonType.outline,
                        theme: TDButtonTheme.primary,
                        onTap: () async {
                          await themeStore.setLightMode();
                          TDToast.showText('已切换到浅色模式', context: context);
                        },
                      ),
                      const SizedBox(width: 10),
                      TDButton(
                        text: '深色',
                        size: TDButtonSize.small,
                        type: currentMode == AppThemeMode.dark
                            ? TDButtonType.fill
                            : TDButtonType.outline,
                        theme: TDButtonTheme.primary,
                        onTap: () async {
                          await themeStore.setDarkMode();
                          TDToast.showText('已切换到深色模式', context: context);
                        },
                      ),
                      const SizedBox(width: 10),
                      TDButton(
                        text: '跟随系统',
                        size: TDButtonSize.small,
                        type: currentMode == AppThemeMode.system
                            ? TDButtonType.fill
                            : TDButtonType.outline,
                        theme: TDButtonTheme.primary,
                        onTap: () async {
                          await themeStore.setSystemMode();
                          TDToast.showText('已切换到跟随系统', context: context);
                        },
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TDButton(
                    text: '打开主题设置页面',
                    size: TDButtonSize.small,
                    type: TDButtonType.text,
                    theme: TDButtonTheme.primary,
                    onTap: () {
                      Navigator.pushNamed(context, AppRoutes.themeSettings);
                    },
                  ),
                ],
              );
            }),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          // 循环切换主题
          final currentMode = themeStore.themeMode.value;
          if (currentMode == AppThemeMode.light) {
            await themeStore.setDarkMode();
            TDToast.showText('切换到深色模式', context: context);
          } else if (currentMode == AppThemeMode.dark) {
            await themeStore.setSystemMode();
            TDToast.showText('切换到跟随系统', context: context);
          } else {
            await themeStore.setLightMode();
            TDToast.showText('切换到浅色模式', context: context);
          }
        },
        tooltip: '切换主题',
        child: Watch((context) {
          final mode = themeStore.themeMode.value;
          return Icon(
            mode == AppThemeMode.light
                ? Icons.light_mode
                : mode == AppThemeMode.dark
                    ? Icons.dark_mode
                    : Icons.brightness_auto,
          );
        }),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 0),
    );
  }

  String _getThemeModeName(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return '浅色模式';
      case AppThemeMode.dark:
        return '深色模式';
      case AppThemeMode.system:
        return '跟随系统';
    }
  }
}
