import 'package:flutter/material.dart';

class CheckIconWidget extends StatelessWidget {
  final double size;
  final Color backgroundColor;
  final IconData? icon;
  const CheckIconWidget({
    super.key,
    required this.size,
    required this.backgroundColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size,
      backgroundColor: Colors.lightBlueAccent.shade100,
      child: CircleAvatar(
        radius: size * .95,
        backgroundColor: backgroundColor,
        child: Icon(icon, color: Colors.white),
      ),
    );
  }
}
