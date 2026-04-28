import 'package:flutter/material.dart';

class ColorAdapter {
  static Color colorByProgressLevel(double level) {
    final percentage = level / 100;
    if (percentage < .5) return Colors.red;
    if (percentage > .5 && percentage < .75) return Colors.orange;
    return Colors.blue;
  }

  static Color lightColorByProgressLevel(double level) {
    final percentage = level / 100;
    if (percentage < .5) return Colors.red.shade100;
    if (percentage > .5 && percentage < .75) return Colors.orange.shade100;
    return Colors.blue.shade100;
  }
}
