import 'package:get/get.dart';
import 'package:posto360/repositories/auth/login/login_repository.dart';
import 'package:posto360/repositories/auth/login/login_repository_impl.dart';
import 'package:posto360/services/auth/login/login_service.dart';
import 'package:posto360/services/auth/login/login_service_impl.dart';
import './login_controller.dart';

class LoginBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoginRepository>(
      () => LoginRepositoryImpl(restClient: Get.find()),
    );
    Get.lazyPut<LoginService>(
      () => LoginServiceImpl(loginRepository: Get.find()),
    );
    Get.put(LoginController());
  }
}
