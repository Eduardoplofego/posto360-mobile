import 'package:get/get.dart';

class SplashPageController extends GetxController {
  @override
  Future<void> onReady() async {
    super.onReady();
    await Future.delayed(const Duration(seconds: 2), () {
      Get.offAllNamed('/login');
    });
  }
}
