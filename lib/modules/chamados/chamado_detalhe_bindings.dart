import 'package:get/get.dart';
import 'package:posto360/modules/chamados/chamado_detalhe_controller.dart';
import 'package:posto360/modules/chamados/domain/models/chamado_model.dart';
import 'package:posto360/modules/chamados/domain/repositories/chamados_repository.dart';
import 'package:posto360/modules/chamados/infra/repositories/chamados_repository_impl.dart';
import 'package:posto360/modules/chamados/infra/services/chamados_service.dart';
import 'package:posto360/modules/chamados/services/chamados_service_impl.dart';

class ChamadoDetalheBindings implements Bindings {
  @override
  void dependencies() {
    final idParam = Get.parameters['id'];
    final chamadoId = int.tryParse(idParam ?? '') ?? 0;
    final args = Get.arguments;
    final chamadoArg = args is ChamadoModel ? args : null;

    if (!Get.isRegistered<ChamadosRepository>()) {
      Get.lazyPut<ChamadosRepository>(
        () => ChamadosRepositoryImpl(postoRestClient: Get.find()),
      );
    }
    if (!Get.isRegistered<ChamadosService>()) {
      Get.lazyPut<ChamadosService>(
        () => ChamadosServiceImpl(chamadosRepository: Get.find()),
      );
    }

    Get.put(
      ChamadoDetalheController(
        chamadoId: chamadoId,
        chamadoArg: chamadoArg,
        chamadosService: Get.find(),
      ),
    );
  }
}
