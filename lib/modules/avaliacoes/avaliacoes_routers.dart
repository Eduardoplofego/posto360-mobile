import 'package:get/get.dart';
import 'package:posto360/modules/avaliacoes/avaliacoes_bindings.dart';
import 'package:posto360/modules/avaliacoes/avaliacoes_criterios_bindings.dart';
import 'package:posto360/modules/avaliacoes/avaliacoes_page.dart';
import 'package:posto360/modules/avaliacoes/avaliacoes_detalhes_page.dart';

class AvaliacoesRouters {
  AvaliacoesRouters._();

  static final routes = <GetPage>[
    GetPage(
      name: '/avaliacoes/detalhes/',
      page: () => const AvaliacoesCriteriosPage(),
      binding: AvaliacoesCriteriosBindings(),
    ),
    GetPage(
      name: '/avaliacoes/:month',
      page: () => AvaliacoesPage(),
      binding: AvaliacoesBindings(),
    ),
  ];
}
