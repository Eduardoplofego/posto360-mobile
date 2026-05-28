import 'package:get/get.dart';
import 'package:posto360/modules/campanhas_gerente/campanhas_gerente_bindings.dart';
import 'package:posto360/modules/campanhas_gerente/campanhas_gerente_page.dart';

class CampanhasGerenteRouters {
  CampanhasGerenteRouters._();

  static final routes = <GetPage>[
    GetPage(
      name: '/campanhas-gerente/:month',
      page: () => const CampanhasGerentePage(),
      binding: CampanhasGerenteBindings(),
    ),
  ];
}
