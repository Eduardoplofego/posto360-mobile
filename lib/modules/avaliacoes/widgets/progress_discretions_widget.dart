import 'package:flutter/material.dart';
import 'package:posto360/modules/avaliacoes/domain/adapters/color_adapter.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';

class ProgressDiscretionsWidget extends StatelessWidget {
  final int totaldiscretions;
  final int concludedsDiscretions;
  const ProgressDiscretionsWidget({
    super.key,
    required this.totaldiscretions,
    required this.concludedsDiscretions,
  });

  @override
  Widget build(BuildContext context) {
    final progress = (concludedsDiscretions / totaldiscretions) * 100;
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$concludedsDiscretions de $totaldiscretions critérios cumpridos',
            ),
            Text(
              '${progress.toStringAsFixed(0)}%',
              style: TextStyle(
                color: ColorAdapter.colorByProgressLevel(progress),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        SizedBox(
          height: 5,
          child: LinearProgressIndicator(
            value: progress / 100,
            color: ColorAdapter.colorByProgressLevel(progress),
            backgroundColor: PostoAppUiConfigurations.lightPurpleColor,
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ],
    );
  }
}
