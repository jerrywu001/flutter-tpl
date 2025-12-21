import 'package:first_app/config/routes.dart';
import 'package:first_app/utils/tools.dart';
import 'package:first_app/widgets/bottom_nav.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _counter = 0;

  void _incrementCounter() async {
    final result = await showConfirm(
      context,
      title: '确认',
      content: '是否确认增加计数器？',
    );

    if (!mounted || result != true) return;

    setState(() {
      _counter++;
    });

    showToast(context, 'Counter incremented');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('首页'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
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
