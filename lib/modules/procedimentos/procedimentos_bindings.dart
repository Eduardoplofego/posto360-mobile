import 'package:get/get.dart';
import './procedimentos_controller.dart';

class ProcedimentosBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(ProcedimentosController());
  }
}
