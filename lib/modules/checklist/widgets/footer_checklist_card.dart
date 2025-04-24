import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';
import 'package:posto360/core/utils/enums/checklist_status.dart';
import 'package:posto360/models/checklist_model.dart';

class FooterChecklistCard extends StatelessWidget {
  final ChecklistModel checklist;
  const FooterChecklistCard({super.key, required this.checklist});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: PostoAppUiConfigurations.lightPurpleColor,
            child: Icon(Icons.person),
          ),
          const SizedBox(width: 6),
          SizedBox(
            width: 140,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${checklist.status.description()} por',
                  style: TextStyle(
                    color: PostoAppUiConfigurations.darkGreyColor,
                    fontSize: 12,
                  ),
                ),
                Text(
                  'Indefinido',
                  style: TextStyle(
                    color: PostoAppUiConfigurations.textDarkColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Spacer(),
          SizedBox(
            width: 115,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Última interação',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: PostoAppUiConfigurations.darkGreyColor,
                    fontSize: 12,
                  ),
                ),
                Text(
                  DateFormat('dd/MM/yyyy').format(DateTime.now()),
                  style: TextStyle(
                    color: PostoAppUiConfigurations.textDarkColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
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
