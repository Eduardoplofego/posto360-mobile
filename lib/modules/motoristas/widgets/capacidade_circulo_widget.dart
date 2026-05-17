import 'package:flutter/material.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';

class CapacidadeCirculoWidget extends StatelessWidget {
  final double percentual;
  final double size;

  const CapacidadeCirculoWidget({
    super.key,
    required this.percentual,
    this.size = 40,
  });

  Color _ringColor() {
    if (percentual < 0.30) return Colors.red.shade400;
    if (percentual < 0.70) return Colors.orange.shade400;
    return PostoAppUiConfigurations.blueMediumColor;
  }

  @override
  Widget build(BuildContext context) {
    final color = _ringColor();
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              value: percentual,
              strokeWidth: 4,
              backgroundColor: PostoAppUiConfigurations.lightGreyBgColor,
              valueColor: AlwaysStoppedAnimation<Color>(color),
            ),
          ),
          Text(
            '${(percentual * 100).round()}%',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: PostoAppUiConfigurations.textDarkColor,
            ),
          ),
        ],
      ),
    );
  }
}
