import 'package:flutter/material.dart';
import '../pages/data_list.dart';

class AppRoutes {
  static const String home = '/';
  static const String dataList = '/data_list';

  static const String initialRoute = home;

  static Map<String, WidgetBuilder> routes = {
    dataList: (context) => const DataListPage(),
  };
}