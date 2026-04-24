import 'package:get/get.dart';
import 'package:posto360/modules/dash_gerente/dash_gerente_bindings.dart';
import 'package:posto360/modules/dash_gerente/dash_gerente_page.dart';

class DashGerenteRouters {
  DashGerenteRouters._();

  static final routes = <GetPage>[
    GetPage(
      name: '/dashboard-gerente',
      page: () => const DashGerentePage(),
      binding: DashGerenteBindings(),
    ),
  ];
}
