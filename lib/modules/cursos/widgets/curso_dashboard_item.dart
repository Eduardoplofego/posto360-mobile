import 'package:flutter/material.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';

class CursoDashboardItem extends StatelessWidget {
  final String image;
  final String text;
  final String value;
  const CursoDashboardItem({
    super.key,
    required this.image,
    required this.text,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    final size = 35.0;
    return Row(
      spacing: 6,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Image.asset(image, width: size, height: size),
        Flexible(
          child: RichText(
            textAlign: TextAlign.justify,
            text: TextSpan(
              children: [
                TextSpan(
                  text: '$text ',
                  style: TextStyle(
                    color: PostoAppUiConfigurations.textDarkColor,
                  ),
                ),
                TextSpan(
                  text: value,
                  style: TextStyle(
                    color: PostoAppUiConfigurations.textDarkColor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
