import 'package:flutter/material.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';

class AvaliatorWidget extends StatelessWidget {
  final String name;
  final String leadingText;
  final String createdAt;
  const AvaliatorWidget({
    super.key,
    required this.name,
    required this.createdAt,
    required this.leadingText,
  });

  String _initialNames(String name) {
    final nameSplitted = name.split(' ');
    if (nameSplitted.length == 1) {
      return name.substring(0, 1).toUpperCase();
    }
    return '${nameSplitted[0].substring(0, 1).toUpperCase()}${nameSplitted[1].substring(0, 1).toUpperCase()}';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.blue.shade100,
            shape: BoxShape.circle,
          ),
          child: Text(
            _initialNames(name),
            style: TextStyle(
              color: PostoAppUiConfigurations.blueMediumColor,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Expanded(
          child: RichText(
            text: TextSpan(
              text: '$leadingText ',
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              children: [
                TextSpan(
                  text: name,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
        Text(createdAt, style: TextStyle(fontSize: 12)),
      ],
    );
  }
}
