import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/core/domain/services/auth_service.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/core/domain/utils/enums/checklist_status.dart';
import 'package:posto360/modules/checklist/domain/models/checklist_model.dart';

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
                  Get.find<AuthService>().getUser()?.name ?? 'Indefinido',
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
