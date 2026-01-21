// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:ybx_parent_client/api/home/index.dart';
import 'package:ybx_parent_client/config/routes.dart';
import 'package:ybx_parent_client/stores/index.dart';
import 'package:ybx_parent_client/types/home/index.dart';
import 'package:ybx_parent_client/utils/index.dart';
import 'package:ybx_parent_client/widgets/bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SignalsMixin {
  /// 计算属性：基于 counter 的派生值（在 Widget 内部定义）
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
          SystemLog.error('用户ID: ${item.userId}');
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
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('首页')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                if (!context.mounted) return;
                await fetchNearbyCompanions();
                Navigator.pushNamed(context, AppRoutes.detail);
              },
              child: const Text('Go to Data List'),
            ),
            const SizedBox(height: 10),
            const Text('下面展示了store在视图中的几种使用方式：'),
            Text(computedFullName.value),
            // 来自 Store 的 computed
            Watch((context) => Text(counterStore.fullName.value)),
            // 使用 Watch 监听 原始 signal 变化
            Watch(
              (context) => Text(
                'counter updated by Watch: ${counterStore.counter.value}',
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: counterStore.increment,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 0),
    );
  }
}
