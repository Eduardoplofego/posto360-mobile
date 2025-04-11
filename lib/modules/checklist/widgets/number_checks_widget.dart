import 'package:flutter/material.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';

class NumberChecksWidget extends StatelessWidget {
  final int concludedChecks;
  final int totalChecks;
  const NumberChecksWidget({
    super.key,
    required this.concludedChecks,
    required this.totalChecks,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        spacing: 16,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: PostoAppUiConfigurations.lightPurpleColor,
            ),
            child: Text(
              '$totalChecks tarefas',
              style: TextStyle(
                color: PostoAppUiConfigurations.blueMediumColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
              color: PostoAppUiConfigurations.lightPurpleColor,
            ),
            child: Text(
              '$concludedChecks concluídas',
              style: TextStyle(
                color: PostoAppUiConfigurations.blueMediumColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
