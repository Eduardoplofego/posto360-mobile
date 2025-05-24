import 'package:get/get.dart';
import './cursos_controller.dart';

class CursosBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(CursosController());
  }
}
