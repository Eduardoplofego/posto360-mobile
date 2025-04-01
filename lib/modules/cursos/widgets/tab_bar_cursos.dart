import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/cursos/cursos_controller.dart';

class TabBarCursos extends GetView<CursosController> {
  const TabBarCursos({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Row(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                !controller.isConcludedCursosSelected
                    ? Row(
                      children: [
                        Container(
                          height: 6,
                          width: 6,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.shade100,
                                blurRadius: 3,
                                spreadRadius: 3,
                              ),
                            ],
                            color: PostoAppUiConfigurations.blueMediumColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    )
                    : const SizedBox.shrink(),
                InkWell(
                  onTap: () => controller.changeSelectedTab(0),
                  child: Text('Em andamento'),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                controller.isConcludedCursosSelected
                    ? Row(
                      children: [
                        Container(
                          height: 6,
                          width: 6,
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.shade100,
                                blurRadius: 3,
                                spreadRadius: 3,
                              ),
                            ],
                            color: PostoAppUiConfigurations.blueMediumColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        const SizedBox(width: 8),
                      ],
                    )
                    : const SizedBox.shrink(),
                InkWell(
                  onTap: () => controller.changeSelectedTab(1),
                  child: Text('Concluídos'),
                ),
              ],
            ),
          ),
        ],
      );
    });
  }
}
