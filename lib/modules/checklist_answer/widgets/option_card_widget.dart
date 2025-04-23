import 'package:flutter/material.dart';

class OptionCardWidget extends StatelessWidget {
  final bool isSelected;
  final String label;
  final Function(bool value) onPressed;
  const OptionCardWidget({
    super.key,
    required this.label,
    required this.isSelected,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 55,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Colors.grey),
      ),
      child: Row(
        children: [
          Checkbox(value: isSelected, onChanged: (value) => onPressed(value!)),
          Text(label),
        ],
      ),
    );
  }
}
