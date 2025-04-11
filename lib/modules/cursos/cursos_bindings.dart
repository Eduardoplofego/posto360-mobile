import 'package:get/get.dart';
import 'package:posto360/repositories/cursos/cursos_repository.dart';
import 'package:posto360/repositories/cursos/cursos_repository_impl.dart';
import 'package:posto360/services/cursos/cursos_service.dart';
import 'package:posto360/services/cursos/cursos_service_impl.dart';
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
