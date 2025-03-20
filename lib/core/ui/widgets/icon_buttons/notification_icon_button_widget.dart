import 'package:flutter/material.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';

class NotificationIconButtonWidget extends StatelessWidget {
  final VoidCallback onPressed;
  const NotificationIconButtonWidget({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      color: Colors.white,
      padding: EdgeInsets.all(8),
      style: IconButton.styleFrom(
        backgroundColor: PostoAppUiConfigurations.blueMediumColor,
      ),
      icon: Icon(Icons.notifications_none_rounded, size: 30),
    );
  }
}
