import 'dart:convert';

class FaltasAtrasosModel {
  final int faltasInjustificadas;
  final int faltasPonto;
  final int atrasosGrave;
  final int atrasosMedio;
  final int atrasosLeve;
  final int penalidade;

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
      faltasInjustificadas: map['Falta injustificado'] ?? 0,
      faltasPonto: map['Falta de ponto'] ?? 0,
      atrasosGrave: map['Atraso grave'] ?? 0,
      atrasosMedio: map['Atraso medio'] ?? 0,
      atrasosLeve: map['Atraso leve'] ?? 0,
      penalidade: map['Penalidade'] ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory FaltasAtrasosModel.fromJson(String source) =>
      FaltasAtrasosModel.fromMap(json.decode(source));
}
