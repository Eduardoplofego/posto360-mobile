class DetalhesCartoesModel {
  final String data;
  final int cartoesCorrigidos;
  final int cartoesDeletados;
  final int cartoesVinculados;
  final double diferenca;

  DetalhesCartoesModel({
    required this.data,
    required this.cartoesCorrigidos,
    required this.cartoesDeletados,
    required this.cartoesVinculados,
    required this.diferenca,
  });

  factory DetalhesCartoesModel.fromMap(Map<String, dynamic> map) {
    return DetalhesCartoesModel(
      data: map['data'] as String,
      cartoesCorrigidos: map['cartoesCorrigidos'] as int,
      cartoesDeletados: map['cartoesDeletados'] as int,
      cartoesVinculados: map['cartoesVinculados'] as int,
      diferenca: (map['diferenca'] as num).toDouble(),
    );
  }
}
