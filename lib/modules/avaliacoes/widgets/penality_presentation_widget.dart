import 'package:flutter/material.dart';

class PenalityPresentationWidget extends StatelessWidget {
  final double penality;
  final Color defaultColor;
  final Color lightColor;
  const PenalityPresentationWidget({
    super.key,
    required this.penality,
    required this.defaultColor,
    required this.lightColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: lightColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        'Penalidade: $penality',
        style: TextStyle(
          color: defaultColor,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }
}
