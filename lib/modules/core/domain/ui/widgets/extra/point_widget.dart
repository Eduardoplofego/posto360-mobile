import 'package:flutter/material.dart';

class PointWidget extends StatelessWidget {
  const PointWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 16,
      width: 16,
      decoration: BoxDecoration(
        color: Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(color: Color(0xFF7BA9F2), width: 2),
      ),
      child: Center(
        child: Container(width: 4, height: 4, color: Color(0xFF7BA9F2)),
      ),
    );
  }
}
