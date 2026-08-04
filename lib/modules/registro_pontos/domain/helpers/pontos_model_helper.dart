import 'package:posto360/modules/registro_pontos/domain/models/batida_model.dart';
import 'package:posto360/modules/registro_pontos/domain/models/pontos_model.dart';

PontosModel getFromMap(Map<String, dynamic> map) {
  final entrada1 = map['entrada1Batida'] as String?;
  final entrada2 = map['entrada2Batida'] as String?;
  final saida1 = map['saida1Batida'] as String?;
  final saida2 = map['saida2Batida'] as String?;

  final data = DateTime.parse(map['data']);

  return PontosModel(
    data: data,
    pontos: [
      _parseBatida(entrada1),
      _parseBatida(saida1),
      _parseBatida(entrada2),
      _parseBatida(saida2),
    ],
  );
}

BatidaModel _parseBatida(String? input) {
  if (input == null) return const BatidaModel.vazia();
  final regex = RegExp(r'^(\d{2}):(\d{2})(?:\s*\(([^)]*)\))?$');
  final match = regex.firstMatch(input.trim());
  if (match == null) return const BatidaModel.vazia();

  final marcador = match.group(3)?.trim();

  return BatidaModel(
    hora: '${match.group(1)}:${match.group(2)}',
    marcador: (marcador == null || marcador.isEmpty) ? null : marcador,
  );
}
