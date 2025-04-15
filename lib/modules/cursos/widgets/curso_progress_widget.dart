import 'package:flutter/material.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';

class CursoProgressWidget extends StatelessWidget {
  final int totalAulas;
  final int aulasFinalizadas;
  const CursoProgressWidget({
    super.key,
    required this.totalAulas,
    required this.aulasFinalizadas,
  });

  @override
  Widget build(BuildContext context) {
    final percent = aulasFinalizadas / totalAulas;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${(percent * 100).toStringAsFixed(0)}% concluído',
              style: TextStyle(
                color: PostoAppUiConfigurations.blueMediumColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Aulas $aulasFinalizadas/$totalAulas',
              style: TextStyle(
                color: PostoAppUiConfigurations.blueMediumColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        LinearProgressIndicator(
          value: percent,
          backgroundColor: PostoAppUiConfigurations.lightPurpleColor,
          color: PostoAppUiConfigurations.blueMediumColor,
          borderRadius: BorderRadius.circular(20),
          minHeight: 6,
        ),
      ],
    );
  }
}
