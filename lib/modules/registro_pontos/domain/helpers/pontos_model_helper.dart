import 'package:posto360/modules/registro_pontos/domain/models/pontos_model.dart';

PontosModel getFromMap(Map<String, dynamic> map) {
  final entrada1 = map['entrada1Batida'] as String?;
  final entrada2 = map['entrada2Batida'] as String?;
  final saida1 = map['saida1Batida'] as String?;
  final saida2 = map['saida2Batida'] as String?;

  final entrada1Formatada = _formatTime(entrada1);
  final entrada2Formatada = _formatTime(entrada2);
  final saida1Formatada = _formatTime(saida1);
  final saida2Formatada = _formatTime(saida2);

  final data = DateTime.parse(map['data']);

  return PontosModel(
    data: data,
    pontos: [
      entrada1Formatada,
      saida1Formatada,
      entrada2Formatada,
      saida2Formatada,
    ],
  );
}

String _formatTime(String? input) {
  if (input == null) return '-';
  final regex = RegExp(r'^(\d{2}):(\d{2})(?:\s*\(.*\))?$');
  final match = regex.firstMatch(input);
  if (match != null) {
    return '${match.group(1)}:${match.group(2)}';
  }
  return '-';
}
