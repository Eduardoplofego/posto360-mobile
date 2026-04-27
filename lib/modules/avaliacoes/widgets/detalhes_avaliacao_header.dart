import 'package:flutter/material.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';

class DetalhesAvaliacaoHeader extends StatelessWidget {
  final int totalDiscretions;
  final int concludedDiscretions;
  final double penality;
  final String comment;
  const DetalhesAvaliacaoHeader({
    super.key,
    required this.totalDiscretions,
    required this.concludedDiscretions,
    required this.penality,
    required this.comment,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        spacing: 10,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            spacing: 10,
            children: [
              topCardDetail(
                title: 'Critérios',
                value: totalDiscretions.toString(),
                textColor: Colors.black,
              ),
              topCardDetail(
                title: 'Cumpridos',
                value: concludedDiscretions.toString(),
                textColor: PostoAppUiConfigurations.blueLightColor,
              ),
              topCardDetail(
                title: 'Penalidade',
                value: penality.toStringAsFixed(1),
                textColor: const Color.fromARGB(255, 170, 45, 37),
              ),
            ],
          ),
          comment.isNotEmpty
              ? Text(
                'Comentário: "$comment"',
                style: TextStyle(
                  fontSize: 12,
                  color: PostoAppUiConfigurations.greyColor,
                ),
              )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  Widget topCardDetail({
    required String title,
    required String value,
    required Color textColor,
  }) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        constraints: BoxConstraints(maxWidth: 90),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 236, 236, 236),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(title, style: TextStyle(fontSize: 12)),
            Text(
              value.toString(),
              style: TextStyle(
                color: textColor,
                fontSize: 18,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
