import 'package:flutter/material.dart';

import 'config/routes.dart';
import 'pages/home/index.dart';
import 'utils/size_fit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      // theme: ThemeData(
      //   colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      // ),
      initialRoute: AppRoutes.home,
      builder: (context, child) {
        SizeFit.initialize(context);
        return child ?? const SizedBox.shrink();
      },
      routes: {
        AppRoutes.home: (context) =>
            const MyHomePage(title: 'Flutter Demo Home Page'),
        ...AppRoutes.routes,
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => MyHomePageState();
}

class MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const MessageScreen(),
    const MineScreen(),
  ];

  void onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _screens[_selectedIndex];
  }
}
