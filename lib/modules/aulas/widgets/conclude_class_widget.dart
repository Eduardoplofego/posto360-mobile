import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/core/domain/utils/enums/aula_status.dart';
import 'package:posto360/modules/aulas/aulas_controller.dart';

class ConcludeClassWidget extends GetView<AulasController> {
  const ConcludeClassWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      bool isCurrentConcluded =
          controller.currentAula?.status == AulaStatus.finalizado;
      return controller.hasData && !controller.isLoading
          ? Container(
            width: Get.width,
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 9),
            color: Color(0xFF1A43BF),
            child: Column(
              children: [
                Row(
                  spacing: 8,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    controller.isVisulizeAulaLoading
                        ? SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(color: Colors.green),
                        )
                        : const SizedBox.shrink(),
                    isCurrentConcluded
                        ? Icon(Icons.check, color: Colors.green, size: 20)
                        : const SizedBox.shrink(),
                    TextButton(
                      onPressed:
                          !isCurrentConcluded
                              ? () async {
                                await controller.visualizeAula();
                              }
                              : null,
                      style: TextButton.styleFrom(padding: EdgeInsets.zero),
                      child: Text(
                        isCurrentConcluded
                            ? 'Assistida'
                            : 'Marcar como assistida',
                        style: TextStyle(
                          color:
                              isCurrentConcluded ? Colors.green : Colors.white,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          )
          : const SizedBox.shrink();
    });
  }
}
