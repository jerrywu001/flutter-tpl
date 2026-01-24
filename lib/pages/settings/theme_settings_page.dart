import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:ybx_parent_client/stores/index.dart';
import 'package:ybx_parent_client/utils/index.dart';

/// 主题设置页面
class ThemeSettingsPage extends StatelessWidget {
  const ThemeSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const TDText('主题设置'), centerTitle: true),
      body: Padding(
        padding: EdgeInsets.symmetric(vertical: 24.rpx),
        child: Column(
          children: [
            // 跟随系统开关
            Watch((context) {
              final isSystemMode =
                  themeStore.themeMode.value == AppThemeMode.system;

              return TDCellGroup(
                theme: TDCellGroupTheme.cardTheme,
                cells: [
                  TDCell(
                    title: '跟随系统',
                    note: '开启后，主题将跟随系统自动调整',
                    rightIconWidget: TDSwitch(
                      isOn: isSystemMode,
                      onChanged: (isOn) {
                        if (isOn) {
                          SystemLog.info('系统跟随已打开');

                          themeStore.setSystemMode();
                        } else {
                          SystemLog.info('系统跟随已关闭');
                          final brightness = MediaQuery.platformBrightnessOf(
                            context,
                          );
                          if (brightness == Brightness.dark) {
                            themeStore.setDarkMode();
                          } else {
                            themeStore.setLightMode();
                          }
                        }

                        return isOn;
                      },
                    ),
                    disabled: true,
                  ),
                ],
              );
            }),

            SizedBox(height: 16.rpx),

            // 手动选择主题
            Watch((context) {
              final currentMode = themeStore.themeMode.value;
              final systemBrightness = MediaQuery.platformBrightnessOf(context);

              // 判断是否选中某个模式
              bool isSelected(AppThemeMode mode) {
                if (currentMode == mode) return true;
                // 跟随系统时，根据系统主题显示选中状态
                if (currentMode == AppThemeMode.system) {
                  if (mode == AppThemeMode.light &&
                      systemBrightness == Brightness.light) {
                    return true;
                  }
                  if (mode == AppThemeMode.dark &&
                      systemBrightness == Brightness.dark) {
                    return true;
                  }
                }
                return false;
              }

              return TDCellGroup(
                theme: TDCellGroupTheme.cardTheme,
                title: '手动选择',
                cells: [
                  TDCell(
                    title: '浅色模式',
                    leftIcon: TDIcons.mode_light,
                    rightIcon: isSelected(AppThemeMode.light)
                        ? TDIcons.check
                        : null,
                    onClick: (cell) async {
                      await themeStore.setLightMode();
                    },
                  ),
                  TDCell(
                    title: '深色模式',
                    leftIcon: TDIcons.mode_dark,
                    rightIcon: isSelected(AppThemeMode.dark)
                        ? TDIcons.check
                        : null,
                    onClick: (cell) async {
                      await themeStore.setDarkMode();
                    },
                  ),
                ],
              );
            }),
          ],
        ),
      ),
    );
  }
}
