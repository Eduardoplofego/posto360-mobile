import 'package:get/get.dart';
import 'package:posto360/modules/campanhas/campanhas_page.dart';
import 'package:posto360/modules/campanhas_gerente/campanhas_gerente_bindings.dart';

class CampanhasGerenteRouters {
  CampanhasGerenteRouters._();

  static final routes = <GetPage>[
    GetPage(
      name: '/campanhas-gerente/:month',
      page: () => const CampanhasPage(),
      binding: CampanhasGerenteBindings(),
    ),
  ];
}
