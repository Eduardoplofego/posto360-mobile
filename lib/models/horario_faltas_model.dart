import 'dart:convert';

class HorarioFaltasModel {
  final String horarioPrevisto;
  final int faltas;
  final int atrasos;

  HorarioFaltasModel({
    required this.horarioPrevisto,
    required this.faltas,
    required this.atrasos,
  });

  Map<String, dynamic> toMap() {
    return {
      'horarioPrevisto': horarioPrevisto,
      'faltas': faltas,
      'atrasos': atrasos,
    };
  }

  factory HorarioFaltasModel.fromMap(Map<String, dynamic> map) {
    return HorarioFaltasModel(
      horarioPrevisto: map['horarioPrevisto'] ?? '',
      faltas: map['faltas']?.toInt() ?? 0,
      atrasos: map['atrasos']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory HorarioFaltasModel.fromJson(String source) =>
      HorarioFaltasModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'HorarioFaltas(horarioPrevisto: $horarioPrevisto, faltas: $faltas, atrasos: $atrasos)';
}
