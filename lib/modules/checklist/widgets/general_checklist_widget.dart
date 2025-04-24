import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/checklist/checklist_controller.dart';

class GeneralChecklistWidget extends GetView<ChecklistController> {
  const GeneralChecklistWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Get.width,
      child: Obx(() {
        return Row(
          children: [
            Spacer(),
            InkWell(
              onTap: () => controller.selectChecklist(true),
              child: Row(
                children: [
                  controller.isRunningChecklistSelected
                      ? Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Container(
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
                      )
                      : const SizedBox.shrink(),
                  Text(
                    '${controller.checklistRunning} em andamento',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color:
                          controller.isRunningChecklistSelected
                              ? PostoAppUiConfigurations.textDarkColor
                              : PostoAppUiConfigurations.darkGreyColor,
                    ),
                  ),
                ],
              ),
            ),
            // const SizedBox(width: 16),
            Spacer(),
            InkWell(
              onTap: () => controller.selectChecklist(false),
              child: Row(
                children: [
                  !controller.isRunningChecklistSelected
                      ? Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: Container(
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
                      )
                      : const SizedBox.shrink(),
                  Text(
                    '${controller.checklistsConcluded} concluídos',
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      color:
                          !controller.isRunningChecklistSelected
                              ? PostoAppUiConfigurations.textDarkColor
                              : PostoAppUiConfigurations.darkGreyColor,
                    ),
                  ),
                ],
              ),
            ),
            Spacer(),
          ],
        );
      }),
    );
  }
}
