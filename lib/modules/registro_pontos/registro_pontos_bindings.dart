import 'package:get/get.dart';
import 'package:posto360/modules/registro_pontos/domain/repositories/registro_pontos_repository.dart';
import 'package:posto360/modules/registro_pontos/services/registro_pontos_services_impl.dart';
import 'package:posto360/modules/registro_pontos/infra/repositories/registro_pontos_repository_impl.dart';
import 'package:posto360/modules/registro_pontos/infra/services/registro_pontos_services.dart';
import 'registro_pontos_controller.dart';

class RegistroPontosBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegistroPontosRepository>(
      () => RegistroPontosRepositoryImpl(Get.find()),
    );
    Get.lazyPut<RegistroPontosServices>(
      () => RegistroPontosServicesImpl(Get.find()),
    );
    Get.put<RegistroPontosController>(
      RegistroPontosController(Get.find(), Get.find()),
    );
  }
}
