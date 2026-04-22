import 'package:get/get.dart';
import 'package:posto360/modules/dash/dash_bindings.dart';
import 'package:posto360/modules/dash/dash_page.dart';

class DashboardRouters {
  DashboardRouters._();

  static final routes = <GetPage>[
    GetPage(
      name: '/dashboard',
      page: () => DashPage(),
      binding: DashBindings(),
    ),
  ];
}
