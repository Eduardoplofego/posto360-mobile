import 'package:get/get.dart';
import 'package:posto360/modules/login/login_bindings.dart';
import 'package:posto360/modules/login/login_page.dart';

class LoginRouters {
  LoginRouters._();

  static final routes = <GetPage>[
    GetPage(
      name: '/login',
      page: () => const LoginPage(),
      binding: LoginBindings(),
    ),
  ];
}
