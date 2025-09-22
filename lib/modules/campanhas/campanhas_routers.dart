import 'package:get/get.dart';
import 'package:posto360/modules/campanhas/campanhas_bindings.dart';
import 'package:posto360/modules/campanhas/campanhas_page.dart';

class CampanhasRouters {
  CampanhasRouters._();

  static final routes = <GetPage>[
    GetPage(
      name: '/campanhas',
      page: () => CampanhasPage(),
      binding: CampanhasBindings(),
    ),
  ];
}
