import 'package:flutter/material.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';

class ButtonCardWidget extends StatelessWidget {
  const ButtonCardWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25),
              bottomRight: Radius.circular(15),
            ),
            color: Colors.white70,
          ),
          child: Icon(
            Icons.arrow_forward_rounded,
            size: 26,
            color: PostoAppUiConfigurations.blueMediumColor,
          ),
        ),
      ],
    );
  }
}
