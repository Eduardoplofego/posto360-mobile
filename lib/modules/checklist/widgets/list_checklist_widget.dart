import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/core/domain/utils/enums/checklist_status.dart';
import 'package:posto360/modules/checklist/checklist_controller.dart';
import 'package:posto360/modules/checklist/widgets/checklist_card_widget.dart';

class ListChecklistWidget extends GetView<ChecklistController> {
  const ListChecklistWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height,
      child: Obx(() {
        if (controller.getChecklistSelected.isEmpty) {
          return Column(
            children: [
              Text(
                'Nenhum checklist disponível',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          );
        } else {
          return ListView.separated(
            physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              final check = controller.getChecklistSelected[index];
              return InkWell(
                onTap: () async {
                  if (check.status == ChecklistStatus.finalizado) {
                    return;
                  }
                  if (check.status == ChecklistStatus.aFazer) {
                    final isToStartChecklist = await controller
                        .showDialogToStartChecklist(check.id);
                    if (isToStartChecklist) {
                      await controller.onRefresh();
                    }
                  } else {
                    await Get.toNamed(
                      '/checklists/answers/',
                      parameters: {
                        'name': check.name,
                        'id': check.id.toString(),
                      },
                    );
                    controller.onRefresh();
                  }
                },
                child: ChecklistCardWidget(checklist: check),
              );
            },
            separatorBuilder: (context, index) => const SizedBox(height: 16),
            itemCount: controller.getChecklistSelected.length,
          );
        }
      }),
    );
  }
}
