import 'package:flutter/material.dart';

class PenalityPresentationWidget extends StatelessWidget {
  final double penality;
  const PenalityPresentationWidget({super.key, required this.penality});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6, vertical: 3),
      decoration: BoxDecoration(
        color: penality < 0 ? Colors.red.shade100 : Colors.grey.shade200,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        'Penalidade: $penality',
        style: TextStyle(
          color: penality < 0 ? Colors.red : Colors.green,
          fontWeight: FontWeight.w500,
          fontSize: 12,
        ),
      ),
    );
  }
}
