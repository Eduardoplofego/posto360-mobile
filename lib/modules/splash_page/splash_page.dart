import 'package:get/get.dart';
import 'package:flutter/material.dart';
import './splash_page_controller.dart';

class SplashPage extends GetView<SplashPageController> {
  const SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF001E61),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo_fundo_azul.png',
              width: Get.width * .7,
            ),
          ],
        ),
      ),
    );
  }
}
