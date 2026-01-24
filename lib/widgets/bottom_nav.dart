import 'package:flutter/material.dart';
import 'package:tdesign_flutter/tdesign_flutter.dart';
import 'package:ybx_parent_client/main.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;

  const BottomNav({super.key, required this.currentIndex});

  @override
  Widget build(BuildContext context) {
    final theme = TDTheme.of(context);

    return BottomNavigationBar(
      backgroundColor: theme.bgColorContainer,
      currentIndex: currentIndex,
      selectedItemColor: theme.brandNormalColor,
      unselectedItemColor: theme.fontGyColor3,
      onTap: (index) {
        context.findAncestorStateOfType<MyHomePageState>()?.onItemTapped(index);
      },
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: '首页'),
        BottomNavigationBarItem(icon: Icon(Icons.message), label: '消息'),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: '我的'),
      ],
    );
  }
}
