import 'package:get/get.dart';
import 'package:posto360/modules/fechamento-caixa/fechamento_caixa_bindings.dart';
import 'package:posto360/modules/fechamento-caixa/fechamento_caixa_screen.dart';

class FechamentoCaixaRouters {
  FechamentoCaixaRouters._();

  static final routes = <GetPage>[
    GetPage(
      name: '/fechamento-caixa/:month',
      page: () => FechamentoCaixaScreen(),
      binding: FechamentoCaixaBindings(),
    ),
  ];
}
