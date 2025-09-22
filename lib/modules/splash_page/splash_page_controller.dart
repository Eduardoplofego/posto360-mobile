import 'package:get/get.dart';
import 'package:posto360/modules/core/domain/services/auth_service.dart';

class SplashPageController extends GetxController {
  @override
  void onReady() {
    Get.putAsync(() => AuthService().init());
    super.onReady();
  }
}
