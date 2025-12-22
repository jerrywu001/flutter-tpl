import 'package:first_app/config/routes.dart';
import 'package:first_app/utils/tools.dart';
import 'package:first_app/widgets/bottom_nav.dart';
import 'package:first_app/widgets/svg_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MineScreen extends StatefulWidget {
  const MineScreen({super.key});

  @override
  State<MineScreen> createState() => _MineScreenState();
}

class _MineScreenState extends State<MineScreen> {
  void _logout() async {
    final result = await showConfirm(
      context,
      title: '提示',
      content: '是否确认退出登录？',
    );

    if (!mounted || result != true) return;

    showToast(context, 'will logout');
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(),
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          systemOverlayStyle: const SystemUiOverlayStyle(
            statusBarColor: Colors.transparent,
            statusBarIconBrightness: Brightness.dark,
          ),
        ),
        body: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/home/mine-bg.png'),
                  fit: BoxFit.fitWidth,
                  alignment: Alignment.topCenter,
                ),
              ),
            ),
            // Main content
            SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 72),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.rpx),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '上海吉舰嘉科技服务有限公司',
                          style: TextStyle(
                            color: const Color(0xFF333333),
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
                            ),
                            SizedBox(width: 8.rpx),
                            Text(
                              '销售顾问 闻晨佳',
                              style: TextStyle(
                                color: const Color(0xFF333333),
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
                            ),
                            SizedBox(width: 8.rpx),
                            Text(
                              '13913380929',
                              style: TextStyle(
                                color: const Color(0xFF333333),
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
                      color: Colors.white,
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
    return InkWell(
      onTap: onTap,
      splashColor: Colors.grey.withValues(alpha: 0.1),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.rpx, vertical: 24.rpx),
        child: Row(
          children: [
            SvgIcon(icon: icon, size: 36.rpx, color: const Color(0xFF333333)),
            SizedBox(width: 8.rpx),
            Text(
              title,
              style: TextStyle(
                color: const Color(0xFF333333),
                fontSize: 28.rpx,
                fontWeight: FontWeight.normal,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 24.rpx,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
