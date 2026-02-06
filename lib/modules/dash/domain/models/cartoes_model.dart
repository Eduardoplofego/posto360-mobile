import 'dart:convert';

class CartoesModel {
  final double diferencaTotal;
  final double penalidade;
  final int cartoesDeletados;
  final int cartoesVinculados;
  final int cartoesCorrigidos;
  final int cartoesInseridos;

  CartoesModel({
    required this.diferencaTotal,
    required this.penalidade,
    required this.cartoesDeletados,
    required this.cartoesVinculados,
    required this.cartoesCorrigidos,
    required this.cartoesInseridos,
  });

  Map<String, dynamic> toMap() {
    return {
      'diferencaTotal': diferencaTotal,
      'penalidade': penalidade,
      'cartoesDeletados': cartoesDeletados,
      'cartoesVinculados': cartoesVinculados,
      'cartoesCorrigidos': cartoesCorrigidos,
      'cartoesInseridos': cartoesInseridos,
    };
  }

  factory CartoesModel.fromMap(Map<String, dynamic> map) {
    return CartoesModel(
      diferencaTotal: map['diferencaTotal']?.toDouble() ?? 0.0,
      penalidade: map['penalidade']?.toDouble() ?? 0.0,
      cartoesDeletados: map['cartoesDeletados']?.toInt() ?? 0,
      cartoesVinculados: map['cartoesVinculados']?.toInt() ?? 0,
      cartoesCorrigidos: map['cartoesCorrigidos']?.toInt() ?? 0,
      cartoesInseridos: map['cartoesInseridos']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory CartoesModel.fromJson(String source) =>
      CartoesModel.fromMap(json.decode(source));
}
