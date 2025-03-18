import 'package:get/get.dart';
import 'package:posto360/core/services/auth_service.dart';

class SplashPageController extends GetxController {
  @override
  void onReady() {
    Get.putAsync(() => AuthService().init());
    super.onReady();
  }
}
