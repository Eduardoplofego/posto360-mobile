import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';
import 'package:posto360/models/checklist_answer_model.dart';
import 'package:posto360/modules/checklist_answer/widgets/check_icon_widget.dart';

class ChecklistAnswerCard extends StatelessWidget {
  final ChecklistAnswerModel answer;
  const ChecklistAnswerCard({super.key, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: Get.width,
      padding: EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Color(0xffECECEC)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(child: Text(answer.descricao)),
                Visibility(
                  visible: answer.respostaDada,
                  replacement: CheckIconWidget(
                    size: 16,
                    backgroundColor: Colors.white,
                  ),
                  child: CheckIconWidget(
                    size: 16,
                    backgroundColor: PostoAppUiConfigurations.blueMediumColor,
                    icon: Icons.check,
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: answer.observacoes != null,
            replacement: const SizedBox.shrink(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                Divider(height: 5, color: Color(0xffECECEC)),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 12,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.chat_outlined, color: Colors.grey.shade400),
                      const SizedBox(width: 16),
                      Flexible(
                        child: Text(
                          answer.observacoes ?? '',
                          style: TextStyle(color: Colors.grey.shade500),
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(height: 5, color: Color(0xffECECEC)),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    'Realizado em: 10/02/2025 às 09h20',
                    style: TextStyle(color: Colors.grey.shade500, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
