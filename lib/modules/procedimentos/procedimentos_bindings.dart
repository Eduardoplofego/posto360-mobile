import 'package:get/get.dart';
import 'package:posto360/modules/procedimentos/domain/repositories/procedimentos_repository.dart';
import 'package:posto360/modules/procedimentos/infra/repositories/procedimentos_repository_impl.dart';
import 'package:posto360/modules/procedimentos/infra/services/procedimentos_service.dart';
import 'package:posto360/modules/procedimentos/services/procedimentos_service_impl.dart';
import './procedimentos_controller.dart';

class ProcedimentosBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProcedimentosRepository>(
      () => ProcedimentosRepositoryImpl(postoRestClient: Get.find()),
    );
    Get.lazyPut<ProcedimentosService>(
      () => ProcedimentosServiceImpl(procedimentosRepository: Get.find()),
    );
    Get.put(ProcedimentosController(procedimentosService: Get.find()));
  }
}
