import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';
import 'package:posto360/core/ui/widgets/custom_app_bar.dart';
import 'package:posto360/core/ui/widgets/general_checklist_widget.dart';
import 'package:posto360/core/ui/widgets/icon_buttons/back_icon_button_widget.dart';
import 'package:posto360/modules/checklist_answer/widgets/checklist_answer_card.dart';
import 'package:posto360/modules/checklist_answer/widgets/modals/answer_checklist_modal.dart';
import './checklist_answer_controller.dart';

class ChecklistAnswerPage extends GetView<ChecklistAnswerController> {
  const ChecklistAnswerPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: CustomAppBar(
          title: 'Checklist',
          leading: BackIconButtonWidget(
            onPressed: () async {
              Get.back();
            },
          ),
          actions: [],
        ),
      ),
      body: Column(
        children: [
          Obx(() {
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: SizedBox(
                width: Get.width,
                child: Text(
                  controller.checklistName,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: PostoAppUiConfigurations.textDarkColor,
                  ),
                ),
              ),
            );
          }),
          Divider(height: 0, color: Colors.grey.shade300),
          Obx(() {
            return GeneralChecklistWidget(
              firstTap: controller.changeSelectTab,
              secondTap: controller.changeSelectTab,
              isFirstSelected: controller.isToConcludedSelect,
              firstNumber: controller.totalToConcludeAnswers,
              secondNumber: controller.totalConcludedAnswers,
              firstText: 'para concluir',
              secondText: 'concluídas',
            );
          }),
          Divider(height: 0, color: Colors.grey.shade300),
          const SizedBox(height: 16),
          Obx(() {
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Visibility(
                  visible:
                      controller.listToShow.isNotEmpty && !controller.isLoading,
                  replacement: Column(
                    children: [
                      const SizedBox(height: 28),
                      Text(
                        'Nenhuma resposta ${!controller.isToConcludedSelect ? 'concluída' : 'a concluir'}',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                    ],
                  ),
                  child: ListView.separated(
                    itemCount: controller.listToShow.length + 1,
                    separatorBuilder:
                        (context, index) => const SizedBox(height: 16),
                    itemBuilder: (context, index) {
                      if (index == controller.listToShow.length) {
                        return const SizedBox(height: 32);
                      } else {
                        final answer = controller.listToShow[index];
                        return ChecklistAnswerCard(
                          answer: answer,
                          onPressed: () async {
                            if (!answer.respostaDada) {
                              controller.selectAnswerModel(answer);
                              await showModalBottomSheet(
                                context: context,
                                isScrollControlled: true,
                                builder: (context) {
                                  return AnswerChecklistModal(
                                    answerModel: answer,
                                  );
                                },
                              );
                              controller.disposeVaribales();
                            }
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
