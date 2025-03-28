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

  factory PerformanceModel.empty() {
    return PerformanceModel(
      campanhaId: 0,
      unidadesVendidas: 0,
      valorBonificacao: 0,
    );
  }

  Map<int, PerformanceModel> toMap() {
    return {campanhaId: this};
  }

  Map<String, dynamic> toMapToSave() {
    return {
      'campanhaId': campanhaId,
      'unidadesVendidas': unidadesVendidas,
      'valorBonificacao': valorBonificacao,
    };
  }

  factory PerformanceModel.fromMap(Map<String, dynamic> map) {
    return PerformanceModel(
      campanhaId: map['campanhaId'] ?? 0,
      unidadesVendidas: map['performance']['unidadesVendidas'] ?? 0.0,
      valorBonificacao: map['performance']['valorBonificacao'] ?? 0.0,
    );
  }

  factory PerformanceModel.fromStorageMap(Map<String, dynamic> map) {
    return PerformanceModel(
      campanhaId: map['campanhaId'] ?? 0,
      unidadesVendidas: map['unidadesVendidas'] ?? 0.0,
      valorBonificacao: map['valorBonificacao'] ?? 0.0,
    );
  }

  String toJson() => json.encode(toMap());

  factory PerformanceModel.fromJson(String source) =>
      PerformanceModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'PerformanceModel(campanhaId: $campanhaId, unidadesVendidas: $unidadesVendidas, valorBonificacao: $valorBonificacao)';
}
