import 'package:get/get.dart';
import 'package:posto360/modules/motoristas/motoristas_bindings.dart';
import 'package:posto360/modules/motoristas/motoristas_page.dart';

class MotoristasRouters {
  MotoristasRouters._();

  static final routes = <GetPage>[
    GetPage(
      name: '/dashboard-motorista',
      binding: MotoristasBindings(),
      page: () => const MotoristasPage(),
    ),
  ];
}
