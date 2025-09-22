import 'package:flutter/material.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/core/domain/utils/enums/checklist_status.dart';
import 'package:posto360/modules/checklist/domain/models/checklist_model.dart';
import 'package:posto360/modules/checklist/widgets/footer_checklist_card.dart';
import 'package:posto360/modules/checklist/widgets/number_checks_widget.dart';

class ChecklistCardWidget extends StatelessWidget {
  final ChecklistModel checklist;
  const ChecklistCardWidget({super.key, required this.checklist});

  @override
  Widget build(BuildContext context) {
    switch (checklist.status) {
      case ChecklistStatus.finalizado:
      case ChecklistStatus.emRevisao:
      case ChecklistStatus.aFazer:
        return _toDoChecklistCard(checklist);
      case ChecklistStatus.emAndamento:
        return _otherChecklistCard(checklist);
    }
  }
}

Widget _toDoChecklistCard(ChecklistModel checklist) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PostoAppUiConfigurations.darkGreyColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                checklist.name,
                style: TextStyle(
                  color: PostoAppUiConfigurations.textDarkColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
              checklist.description != ''
                  ? Text(
                    checklist.description,
                    style: TextStyle(
                      color: PostoAppUiConfigurations.textDarkColor,
                      fontWeight: FontWeight.w400,
                    ),
                  )
                  : const SizedBox.shrink(),
            ],
          ),
        ],
      ),
    ),
  );
}

Widget _otherChecklistCard(ChecklistModel checklist) {
  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16),
    child: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: PostoAppUiConfigurations.darkGreyColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        checklist.name,
                        style: TextStyle(
                          color: PostoAppUiConfigurations.textDarkColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    checklist.status == ChecklistStatus.finalizado
                        ? CircleAvatar(
                          radius: 16,
                          backgroundColor:
                              PostoAppUiConfigurations.lightPurpleColor,
                          child: CircleAvatar(
                            radius: 14,
                            backgroundColor:
                                checklist.status == ChecklistStatus.emRevisao
                                    ? PostoAppUiConfigurations.orangeColor
                                    : PostoAppUiConfigurations.blueMediumColor,
                            child: Icon(
                              checklist.status == ChecklistStatus.emRevisao
                                  ? Icons.timelapse_outlined
                                  : Icons.check,
                              color: Colors.white,
                            ),
                          ),
                        )
                        : const SizedBox.shrink(),
                  ],
                ),
                checklist.description != ''
                    ? Column(
                      children: [
                        const SizedBox(height: 6),
                        Text(
                          checklist.description,
                          style: TextStyle(
                            color: PostoAppUiConfigurations.textDarkColor,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    )
                    : const SizedBox.shrink(),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Divider(),
          const SizedBox(height: 8),
          NumberChecksWidget(
            concludedChecks: checklist.concludedChecks,
            totalChecks: checklist.totalChecks,
          ),
          const SizedBox(height: 8),
          Divider(),
          const SizedBox(height: 4),
          FooterChecklistCard(checklist: checklist),
          const SizedBox(height: 16),
        ],
      ),
    ),
  );
}
