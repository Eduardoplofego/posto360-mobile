import 'package:get/get.dart';
import 'dash_controller.dart';

class DashBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(DashController());
  }
}
