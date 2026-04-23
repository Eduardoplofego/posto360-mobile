import 'package:get/get.dart';
import 'package:posto360/modules/procedimentos/domain/repositories/procedimentos_repository.dart';
import 'package:posto360/modules/procedimentos/infra/repositories/procedimentos_repository_impl.dart';
import 'package:posto360/modules/procedimentos/infra/services/procedimentos_service.dart';
import 'package:posto360/modules/procedimentos/services/procedimentos_service_impl.dart';
import './procedimento_detalhe_controller.dart';

class ProcedimentoDetalheBindings implements Bindings {
  @override
  void dependencies() {
    final idParam = Get.parameters['id'];
    final procedimentoId = int.tryParse(idParam ?? '') ?? 0;

    if (!Get.isRegistered<ProcedimentosRepository>()) {
      Get.lazyPut<ProcedimentosRepository>(
        () => ProcedimentosRepositoryImpl(postoRestClient: Get.find()),
      );
    }
    if (!Get.isRegistered<ProcedimentosService>()) {
      Get.lazyPut<ProcedimentosService>(
        () => ProcedimentosServiceImpl(procedimentosRepository: Get.find()),
      );
    }

    Get.put(
      ProcedimentoDetalheController(
        procedimentoId: procedimentoId,
        procedimentosService: Get.find(),
      ),
    );
  }
}
