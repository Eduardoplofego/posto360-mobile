import 'package:get/get.dart';
import 'package:posto360/modules/equipe/colaborador_detalhe_bindings.dart';
import 'package:posto360/modules/equipe/colaborador_detalhe_page.dart';
import 'package:posto360/modules/equipe/equipe_bindings.dart';
import 'package:posto360/modules/equipe/equipe_page.dart';

class EquipeRouters {
  EquipeRouters._();

  static final routes = <GetPage>[
    GetPage(
      name: '/equipe/:month',
      binding: EquipeBindings(),
      page: () => const EquipePage(),
    ),
    GetPage(
      name: '/equipe/colaborador/:id',
      binding: ColaboradorDetalheBindings(),
      page: () => const ColaboradorDetalhePage(),
    ),
  ];
}
