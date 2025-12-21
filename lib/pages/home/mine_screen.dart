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
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 26.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '上海吉舰嘉科技服务有限公司',
                          style: TextStyle(
                            color: Color(0xFF333333),
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            height: 1.0,
                          ),
                        ),
                        SizedBox(height: 14),
                        Row(
                          children: [
                            SvgIcon(
                              icon: 'assets/home/icon-user.svg',
                              size: 14,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '销售顾问 闻晨佳',
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 4),
                        Row(
                          children: [
                            SvgIcon(
                              icon: 'assets/home/icon-phone.svg',
                              size: 14,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '13913380929',
                              style: TextStyle(
                                color: Color(0xFF333333),
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 26.0),
                    child: Material(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(6),
                      child: Column(
                        children: [
                          menuItem(
                            icon: 'assets/home/icon-password.svg',
                            title: '密码管理',
                            onTap: () {
                              Navigator.pushNamed(context, AppRoutes.editPassword);
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
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
        child: Row(
          children: [
            SvgIcon(
              icon: icon,
              size: 20,
              color: const Color(0xFF333333),
            ),
            const SizedBox(width: 4),
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF333333),
                fontSize: 14,
                fontWeight: FontWeight.normal,
              ),
            ),
            const Spacer(),
            Icon(
              Icons.arrow_forward_ios,
              size: 16,
              color: Colors.grey.shade400,
            ),
          ],
        ),
      ),
    );
  }
}
