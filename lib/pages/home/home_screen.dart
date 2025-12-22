import 'package:flutter/material.dart';
import 'package:ybx_parent_client/api/home/index.dart';
import 'package:ybx_parent_client/config/routes.dart';
import 'package:ybx_parent_client/types/home/index.dart';
import 'package:ybx_parent_client/utils/index.dart';
import 'package:ybx_parent_client/widgets/bottom_nav.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

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
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: const BottomNav(currentIndex: 0),
    );
  }
}
