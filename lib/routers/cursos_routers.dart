import 'package:get/get.dart';
import 'package:posto360/modules/cursos/cursos_bindings.dart';
import 'package:posto360/modules/cursos/cursos_page.dart';

class CursosRouters {
  CursosRouters._();

  static final routes = <GetPage>[
    GetPage(
      name: '/cursos',
      page: () => const CursosPage(),
      binding: CursosBindings(),
    ),
  ];
}
