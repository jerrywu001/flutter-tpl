import 'package:flutter/material.dart';

import '../../../main.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;

  const BottomNav({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: Colors.white,
      currentIndex: currentIndex,
      selectedItemColor: const Color(0xFFA28071),
      unselectedItemColor: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.3),
      onTap: (index) {
        context.findAncestorStateOfType<MyHomePageState>()?.onItemTapped(index);
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '首页',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.message),
          label: '消息',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: '我的',
        ),
      ],
    );
  }
}
