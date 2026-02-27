import 'package:flutter/widgets.dart';

class PontoTimelineModel {
  final DateTime ponto;
  final IconData icon;
  final String text;

  PontoTimelineModel({
    required this.ponto,
    required this.icon,
    required this.text,
  });

  @override
  String toString() =>
      'PontoTimelineModel(ponto: $ponto, icon: $icon, text: $text)';
}
