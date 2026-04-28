import 'package:get/get.dart';
import 'package:posto360/modules/avaliacoes/bindings/avaliacoes_bindings.dart';
import 'package:posto360/modules/avaliacoes/bindings/avaliacoes_criterios_bindings.dart';
import 'package:posto360/modules/avaliacoes/bindings/realizar_avaliacao_bindings.dart';
import 'package:posto360/modules/avaliacoes/pages/avaliacoes_page.dart';
import 'package:posto360/modules/avaliacoes/pages/avaliacoes_detalhes_page.dart';
import 'package:posto360/modules/avaliacoes/pages/realizar_avaliacao_page.dart';

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
    GetPage(
      name: '/avaliacoes/realizar_avaliacao/:avaliacaoId/:modeloId',
      page: () => RealizarAvaliacaoPage(),
      binding: RealizarAvaliacaoBindings(),
    ),
  ];
}
