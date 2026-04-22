import 'package:get/get.dart';
import 'package:posto360/modules/cursos/domain/repositories/cursos_repository.dart';
import 'package:posto360/modules/cursos/infra/repositories/cursos_repository_impl.dart';
import 'package:posto360/modules/cursos/infra/services/cursos_service.dart';
import 'package:posto360/modules/cursos/services/cursos_service_impl.dart';
import './cursos_controller.dart';

class CursosBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CursosRepository>(
      () => CursosRepositoryImpl(postoRestClient: Get.find()),
    );
    Get.lazyPut<CursosService>(
      () => CursosServiceImpl(cursoRepository: Get.find()),
    );
    Get.put(CursosController(cursosService: Get.find()));
  }
}
