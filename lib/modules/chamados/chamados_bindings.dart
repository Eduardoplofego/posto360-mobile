import 'package:get/get.dart';
import 'package:posto360/modules/chamados/chamados_controller.dart';
import 'package:posto360/modules/chamados/domain/repositories/chamados_repository.dart';
import 'package:posto360/modules/chamados/infra/repositories/chamados_repository_impl.dart';
import 'package:posto360/modules/chamados/infra/services/chamados_service.dart';
import 'package:posto360/modules/chamados/services/chamados_service_impl.dart';

class ChamadosBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChamadosRepository>(
      () => ChamadosRepositoryImpl(postoRestClient: Get.find()),
    );
    Get.lazyPut<ChamadosService>(
      () => ChamadosServiceImpl(chamadosRepository: Get.find()),
    );
    Get.put(ChamadosController(chamadosService: Get.find()));
  }
}
