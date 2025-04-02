import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/aulas/aulas_controller.dart';

class ModuleProgress extends GetView<AulasController> {
  const ModuleProgress({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 79,
      width: Get.width,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: Colors.white,
      child: Obx(() {
        return Column(
          children: [
            Row(
              children: [
                Text(
                  'Módulo 1',
                  style: TextStyle(
                    color: PostoAppUiConfigurations.textDarkColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '${((controller.curso!.aulasConcluidas / controller.curso!.totalAulas) * 100).toStringAsFixed(0)}% completo',
                  style: TextStyle(color: PostoAppUiConfigurations.greyColor),
                ),
                Text(
                  'Aulas: ${controller.curso?.aulasConcluidas}/${controller.curso?.totalAulas}',
                  style: TextStyle(color: PostoAppUiConfigurations.greyColor),
                ),
              ],
            ),
            const SizedBox(height: 6),
            LinearProgressIndicator(
              value:
                  controller.curso!.aulasConcluidas /
                  controller.curso!.totalAulas,
              minHeight: 6,
              borderRadius: BorderRadius.circular(10),
              backgroundColor: PostoAppUiConfigurations.lightPurpleColor,
              color: PostoAppUiConfigurations.blueMediumColor,
            ),
          ],
        );
      }),
    );
  }
}
