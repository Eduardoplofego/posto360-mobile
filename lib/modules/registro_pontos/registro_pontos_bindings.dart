import 'package:get/get.dart';
import 'registro_pontos_controller.dart';

class RegistroPontosBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(RegistroPontosController());
  }
}
