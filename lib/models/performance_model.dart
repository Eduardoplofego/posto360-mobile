import 'dart:convert';

class PerformanceModel {
  final int campanhaId;
  final double unidadesVendidas;
  final double valorBonificacao;

  PerformanceModel({
    required this.campanhaId,
    required this.unidadesVendidas,
    required this.valorBonificacao,
  });

  Map<int, PerformanceModel> toMap() {
    return {campanhaId: this};
  }

  factory PerformanceModel.fromMap(Map<String, dynamic> map) {
    return PerformanceModel(
      campanhaId: map['campanhaId']?.toInt() ?? 0,
      unidadesVendidas:
          map['performance']['unidadesVendidas']?.toDouble() ?? 0.0,
      valorBonificacao:
          map['performance']['valorBonificacao']?.toDouble() ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory PerformanceModel.fromJson(String source) =>
      PerformanceModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'PerformanceModel(campanhaId: $campanhaId, unidadesVendidas: $unidadesVendidas, valorBonificacao: $valorBonificacao)';
}
