import 'package:flutter/material.dart';
import 'package:ybx_parent_client/pages/detail.dart';
import 'package:ybx_parent_client/pages/edit_password.dart';

class AppRoutes {
  static const String home = '/';
  static const String detail = '/detail';
  static const String editPassword = '/edit_password';

  static const String initialRoute = home;

  static Map<String, WidgetBuilder> routes = {
    detail: (context) => const DetailPage(),
    editPassword: (context) => const EditPassword(),
  };
}
