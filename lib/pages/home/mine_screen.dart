import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:ybx_parent_client/routes/routes.dart';
import 'package:ybx_parent_client/utils/tools.dart';
import 'package:ybx_parent_client/widgets/bottom_nav.dart';
import 'package:ybx_parent_client/widgets/svg_icon.dart';

class MineScreen extends StatefulWidget {
  const MineScreen({super.key});

  @override
  State<MineScreen> createState() => _MineScreenState();
}

class _MineScreenState extends State<MineScreen> {
  void _logout() {
    showGeneralDialog(
      context: context,
      pageBuilder:
          (
            BuildContext buildContext,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) {
            return TDAlertDialog(
              title: '提示',
              content: '是否确认退出登录？',
              leftBtnAction: () {
                Navigator.pop(context);
                TDToast.showText('cancel', context: context);
              },
              rightBtnAction: () {
                Navigator.pop(context);
                TDToast.showText('will logout', context: context);
              },
            );
          },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = TDTheme.of(context);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final overlayStyle = SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: isDark ? Brightness.light : Brightness.dark,
      statusBarBrightness: isDark ? Brightness.dark : Brightness.light,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: overlayStyle,
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: const AssetImage('assets/home/mine-bg.png'),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter,
                  opacity: isDark ? 0.3 : 1.0,
                ),
              ),
            ),
            // Main content
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 72),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.rpx),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '上海吉舰嘉科技服务有限公司',
                          style: TextStyle(
                            color: theme.fontGyColor1,
                            fontSize: 36.rpx,
                            fontWeight: FontWeight.w600,
                            height: 1.0,
                          ),
                        ),
                        SizedBox(height: 28.rpx),
                        Row(
                          children: [
                            SvgIcon(
                              icon: 'assets/home/icon-user.svg',
                              size: 28.rpx,
                              color: theme.fontGyColor2,
                            ),
                            SizedBox(width: 8.rpx),
                            Text(
                              '销售顾问 闻晨佳',
                              style: TextStyle(
                                color: theme.fontGyColor2,
                                fontSize: 24.rpx,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.rpx),
                        Row(
                          children: [
                            SvgIcon(
                              icon: 'assets/home/icon-phone.svg',
                              size: 28.rpx,
                              color: theme.fontGyColor2,
                            ),
                            SizedBox(width: 8.rpx),
                            Text(
                              '13913380929',
                              style: TextStyle(
                                color: theme.fontGyColor2,
                                fontSize: 24.rpx,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.rpx),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 32.rpx),
                    child: Material(
                      color: theme.bgColorContainer,
                      borderRadius: BorderRadius.circular(12.rpx),
                      child: Column(
                        children: [
                          SizedBox(height: 12.rpx),
                          menuItem(
                            icon: 'assets/home/icon-password.svg',
                            title: '密码管理',
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.editPassword,
                              );
                            },
                          ),
                          menuItem(
                            icon: 'assets/home/icon-customer.svg',
                            title: '主题设置',
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                AppRoutes.themeSettings,
                              );
                            },
                          ),
                          menuItem(
                            icon: 'assets/home/icon-customer.svg',
                            title: '客服电话',
                            onTap: () {},
                          ),
                          menuItem(
                            icon: 'assets/home/icon-logout.svg',
                            title: '退出登录',
                            onTap: _logout,
                            isLast: true,
                          ),
                          SizedBox(height: 12.rpx),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: const BottomNav(currentIndex: 2),
      ),
    );
  }

  Widget menuItem({
    required String icon,
    required String title,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    final theme = TDTheme.of(context);

    return InkWell(
      onTap: onTap,
      splashColor: theme.fontGyColor4.withValues(alpha: 0.1),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.rpx, vertical: 24.rpx),
        child: Row(
          children: [
            SvgIcon(icon: icon, size: 36.rpx, color: theme.fontGyColor1),
            SizedBox(width: 8.rpx),
            Text(
              title,
              style: TextStyle(
                color: theme.fontGyColor1,
                fontSize: 28.rpx,
                fontWeight: FontWeight.normal,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 24.rpx,
              color: theme.fontGyColor3,
            ),
          ],
        ),
      ),
    );
  }
}
