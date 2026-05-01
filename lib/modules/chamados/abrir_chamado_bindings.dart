import 'package:get/get.dart';
import 'package:posto360/modules/chamados/abrir_chamado_controller.dart';
import 'package:posto360/modules/chamados/domain/repositories/chamados_repository.dart';
import 'package:posto360/modules/chamados/infra/repositories/chamados_repository_impl.dart';
import 'package:posto360/modules/chamados/infra/services/chamados_service.dart';
import 'package:posto360/modules/chamados/services/chamados_service_impl.dart';

class AbrirChamadoBindings implements Bindings {
  @override
  void dependencies() {
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
    Get.put(AbrirChamadoController(chamadosService: Get.find()));
  }
}
