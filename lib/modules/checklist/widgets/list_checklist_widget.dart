import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/checklist/checklist_controller.dart';
import 'package:posto360/modules/checklist/widgets/checklist_card_widget.dart';

class ListChecklistWidget extends GetView<ChecklistController> {
  const ListChecklistWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: Get.height * 200,
      child: Obx(() {
        return ListView.separated(
          physics: NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            final check = controller.getChecklistSelected[index];
            return ChecklistCardWidget(checklist: check);
          },
          separatorBuilder: (context, index) => const SizedBox(height: 16),
          itemCount: controller.getChecklistSelected.length,
        );
      }),
    );
  }
}
