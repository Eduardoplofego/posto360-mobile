import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';

class DottedBorderButtonWidget extends StatelessWidget {
  final bool isCompleted;
  final bool isLoading;
  final VoidCallback onTap;
  const DottedBorderButtonWidget({
    super.key,
    required this.isCompleted,
    required this.isLoading,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child:
          !isLoading
              ? Visibility(
                visible: !isCompleted,
                replacement: CircleAvatar(
                  backgroundColor: Colors.green,
                  radius: 17,
                  child: Icon(Icons.check, color: Colors.white),
                ),
                child: DottedBorder(
                  borderType: BorderType.Circle,
                  padding: EdgeInsets.all(6),
                  color: PostoAppUiConfigurations.blueLightColor,
                  child: Icon(
                    Icons.add,
                    size: 20,
                    color: PostoAppUiConfigurations.blueLightColor,
                  ),
                ),
              )
              : CircularProgressIndicator(),
    );
  }
}
