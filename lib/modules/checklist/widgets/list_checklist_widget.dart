import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/core/utils/enums/checklist_status.dart';
import 'package:posto360/modules/checklist/checklist_controller.dart';
import 'package:posto360/modules/checklist/widgets/checklist_card_widget.dart';

class ListChecklistWidget extends GetView<ChecklistController> {
  const ListChecklistWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height,
      child: Obx(() {
        return ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final check = controller.getChecklistSelected[index];
            return InkWell(
              onTap: () async {
                // se checklist nao iniciado perguntar se quer iniciar
                if (check.status == ChecklistStatus.aFazer) {
                  final isToStartChecklist = await controller
                      .showDialogToStartChecklist(check.id);
                  if (isToStartChecklist) {
                    Get.toNamed(
                      '/checklists/answers/',
                      parameters: {
                        'name': check.name,
                        'id': check.id.toString(),
                      },
                    );
                  }
                } else {
                  Get.toNamed(
                    '/checklists/answers/',
                    parameters: {'name': check.name, 'id': check.id.toString()},
                  );
                }
              },
              child: ChecklistCardWidget(checklist: check),
            );
          },
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemCount: controller.getChecklistSelected.length,
        );
      }),
    );
  }
}
