import 'package:flutter/material.dart';
import 'package:ybx_parent_client/main.dart';
import 'package:ybx_parent_client/utils/tools.dart';
import 'package:ybx_parent_client/widgets/bottom_nav.dart';

class MessageScreen extends StatelessWidget {
  const MessageScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('消息')),
      body: Center(
        child: GestureDetector(
          onTap: () {
            context.findAncestorStateOfType<MyHomePageState>()?.onItemTapped(0);
          },
          child: Text('消息页面 - 点击返回首页', style: TextStyle(fontSize: 28.rpx)),
        ),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 1),
    );
  }
}
