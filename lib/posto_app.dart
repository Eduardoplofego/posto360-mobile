import 'package:flutter/material.dart';
import 'package:get/get_navigation/get_navigation.dart';
import 'package:posto360/core/bindings/application_bindings.dart';
import 'package:posto360/core/ui/posto_app_theme.dart';
import 'package:posto360/routers/login_routers.dart';
import 'package:posto360/routers/splash_routers.dart';

class PostoApp extends StatelessWidget {
  const PostoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Posto 360',
      debugShowCheckedModeBanner: false,
      theme: PostoAppTheme.theme,
      initialBinding: ApplicationBindings(),
      getPages: [...SplashRouters.routes, ...LoginRouters.routes],
    );
  }
}
