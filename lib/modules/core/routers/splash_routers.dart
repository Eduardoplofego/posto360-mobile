import 'package:get/get.dart';
import 'package:posto360/modules/splash_page/splash_page.dart';
import 'package:posto360/modules/splash_page/splash_page_bindings.dart';

class SplashRouters {
  SplashRouters._();

  static final routes = <GetPage>[
    GetPage(
      name: '/',
      page: () => const SplashPage(),
      binding: SplashPageBindings(),
    ),
  ];
}
