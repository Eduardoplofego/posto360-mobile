import 'package:get/get.dart';
import 'package:posto360/modules/chamados/abrir_chamado_bindings.dart';
import 'package:posto360/modules/chamados/abrir_chamado_page.dart';
import 'package:posto360/modules/chamados/chamado_detalhe_bindings.dart';
import 'package:posto360/modules/chamados/chamado_detalhe_page.dart';
import 'package:posto360/modules/chamados/chamado_editar_bindings.dart';
import 'package:posto360/modules/chamados/chamado_editar_page.dart';
import 'package:posto360/modules/chamados/chamados_bindings.dart';
import 'package:posto360/modules/chamados/chamados_page.dart';

class ChamadosRouters {
  ChamadosRouters._();

  static final routes = <GetPage>[
    GetPage(
      name: '/chamados',
      binding: ChamadosBindings(),
      page: () => const ChamadosPage(),
    ),
    GetPage(
      name: '/abrir-chamado',
      binding: AbrirChamadoBindings(),
      page: () => const AbrirChamadoPage(),
    ),
    GetPage(
      name: '/editar-chamado/:id',
      binding: ChamadoEditarBindings(),
      page: () => const ChamadoEditarPage(),
    ),
    GetPage(
      name: '/chamados/:id',
      binding: ChamadoDetalheBindings(),
      page: () => const ChamadoDetalhePage(),
    ),
  ];
}
