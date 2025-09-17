import 'package:flutter/material.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';

class NotificationIconButtonWidget extends StatelessWidget {
  final bool hasNotification;
  final VoidCallback onPressed;
  const NotificationIconButtonWidget({
    super.key,
    required this.onPressed,
    this.hasNotification = false,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onPressed,
      color: Colors.white,
      padding: EdgeInsets.all(8),
      style: IconButton.styleFrom(
        backgroundColor: PostoAppUiConfigurations.blueMediumColor,
      ),
      icon: Badge(
        isLabelVisible: hasNotification,
        child: Icon(Icons.notifications_none_rounded, size: 24),
      ),
    );
  }
}
