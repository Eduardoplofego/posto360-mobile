import 'package:get/get.dart';
import 'package:posto360/modules/motoristas/domain/repositories/motoristas_repository.dart';
import 'package:posto360/modules/motoristas/infra/repositories/motoristas_repository_impl.dart';
import 'package:posto360/modules/motoristas/infra/services/motoristas_service.dart';
import 'package:posto360/modules/motoristas/services/motoristas_service_impl.dart';
import './motoristas_controller.dart';

class MotoristasBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MotoristasRepository>(
      () => MotoristasRepositoryImpl(postoRestClient: Get.find()),
    );
    Get.lazyPut<MotoristasService>(
      () => MotoristasServiceImpl(motoristasRepository: Get.find()),
    );
    Get.put(MotoristasController(motoristasService: Get.find()));
  }
}
