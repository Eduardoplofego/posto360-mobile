import 'package:flutter/widgets.dart';
import 'package:posto360/modules/registro_pontos/domain/models/batida_model.dart';

class PontoTimelineModel {
  final BatidaModel ponto;
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
