import 'package:get/get.dart';
import 'package:posto360/modules/procedimentos/procedimento_detalhe_bindings.dart';
import 'package:posto360/modules/procedimentos/procedimento_detalhe_page.dart';
import 'package:posto360/modules/procedimentos/procedimentos_bindings.dart';
import 'package:posto360/modules/procedimentos/procedimentos_page.dart';

class ProcedimentosRouters {
  ProcedimentosRouters._();

  static final routes = <GetPage>[
    GetPage(
      name: '/procedimentos',
      binding: ProcedimentosBindings(),
      page: () => const ProcedimentosPage(),
    ),
    GetPage(
      name: '/procedimentos/:id',
      binding: ProcedimentoDetalheBindings(),
      page: () => const ProcedimentoDetalhePage(),
    ),
  ];
}
