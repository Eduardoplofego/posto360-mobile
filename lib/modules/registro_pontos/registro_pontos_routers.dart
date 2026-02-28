import 'package:get/get.dart';
import 'package:posto360/modules/registro_pontos/registro_pontos_bindings.dart';
import 'package:posto360/modules/registro_pontos/registro_pontos_page.dart';

class RegistroPontosRouters {
  static final routes = <GetPage>[
    GetPage(
      name: '/registro-pontos/:month',
      page: () => RegistroPontosPage(),
      binding: RegistroPontosBindings(),
    ),
  ];
}
