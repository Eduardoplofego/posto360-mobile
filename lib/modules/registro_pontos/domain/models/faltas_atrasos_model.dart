import 'dart:convert';

class FaltasAtrasosModel {
  final num faltasInjustificadas;
  final num faltasPonto;
  final num atrasosGrave;
  final num atrasosMedio;
  final num atrasosLeve;
  final num penalidade;

  FaltasAtrasosModel({
    required this.faltasInjustificadas,
    required this.faltasPonto,
    required this.atrasosGrave,
    required this.atrasosMedio,
    required this.atrasosLeve,
    required this.penalidade,
  });

  factory FaltasAtrasosModel.empty() {
    return FaltasAtrasosModel(
      faltasInjustificadas: 0,
      faltasPonto: 0,
      atrasosGrave: 0,
      atrasosMedio: 0,
      atrasosLeve: 0,
      penalidade: 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'faltasInjustificadas': faltasInjustificadas,
      'faltasPonto': faltasPonto,
      'atrasosGrave': atrasosGrave,
      'atrasosMedio': atrasosMedio,
      'atrasosLeve': atrasosLeve,
      'penalidade': penalidade,
    };
  }

  factory FaltasAtrasosModel.fromMap(Map<String, dynamic> map) {
    return FaltasAtrasosModel(
      faltasInjustificadas: (map['Falta injustificado'] as num?) ?? 0,
      faltasPonto: (map['Falta de ponto'] as num?) ?? 0,
      atrasosGrave: (map['Atraso grave'] as num?) ?? 0,
      atrasosMedio: (map['Atraso medio'] as num?) ?? 0,
      atrasosLeve: (map['Atraso leve'] as num?) ?? 0,
      penalidade: (map['Penalidade'] as num?) ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory FaltasAtrasosModel.fromJson(String source) =>
      FaltasAtrasosModel.fromMap(json.decode(source));
}
