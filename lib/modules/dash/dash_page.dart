import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dash_controller.dart';

class DashPage extends GetView<DashController> {
  const DashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('DashPage')),
      body: Container(),
    );
  }
}
