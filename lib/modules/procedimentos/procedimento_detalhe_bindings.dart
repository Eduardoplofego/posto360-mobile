import 'package:get/get.dart';
import './procedimento_detalhe_controller.dart';

class ProcedimentoDetalheBindings implements Bindings {
  @override
  void dependencies() {
    final idParam = Get.parameters['id'];
    final procedimentoId = int.tryParse(idParam ?? '') ?? 0;
    Get.lazyPut<ProcedimentoDetalheController>(
      () => ProcedimentoDetalheController(procedimentoId: procedimentoId),
      fenix: false,
    );
  }
}
