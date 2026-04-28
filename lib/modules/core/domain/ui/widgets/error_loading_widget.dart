import 'package:flutter/material.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';

class ErrorLoadingWidget extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback reload;
  const ErrorLoadingWidget({
    super.key,
    required this.title,
    required this.message,
    required this.reload,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.error,
            size: 46,
            color: PostoAppUiConfigurations.darkGreyColor,
          ),
          Text(title, style: TextStyle()),
          Text(
            message,
            style: TextStyle(
              color: PostoAppUiConfigurations.darkGreyColor,
              fontSize: 12,
            ),
          ),
          TextButton.icon(
            onPressed: () => reload(),
            label: Text(
              'Recarregar',
              style: TextStyle(color: PostoAppUiConfigurations.blueMediumColor),
            ),
            icon: Icon(
              Icons.refresh,
              color: PostoAppUiConfigurations.blueMediumColor,
            ),
          ),
        ],
      ),
    );
  }
}
