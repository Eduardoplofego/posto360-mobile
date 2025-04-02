import 'package:get/get.dart';
import 'package:posto360/repositories/aulas/aula_repository.dart';
import 'package:posto360/repositories/aulas/aula_repository_impl.dart';
import 'package:posto360/services/aulas/aulas_service.dart';
import 'package:posto360/services/aulas/aulas_service_impl.dart';
import './aulas_controller.dart';

class AulasBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AulaRepository>(
      () => AulaRepositoryImpl(restClient: Get.find()),
    );
    Get.lazyPut<AulasService>(
      () => AulasServiceImpl(aulaRepository: Get.find()),
    );
    Get.put(AulasController(aulasService: Get.find(), authService: Get.find()));
  }
}
