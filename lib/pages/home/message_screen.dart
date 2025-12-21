import 'package:flutter/material.dart';

import '../../main.dart';
import 'widgets/index.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('消息'),
      ),
      body: Center(
        child: GestureDetector(
          onTap: () {
            context.findAncestorStateOfType<MyHomePageState>()?.onItemTapped(0);
          },
          child: const Text('消息页面 - 点击返回首页'),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(currentIndex: 1),
    );
  }
}
