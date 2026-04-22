class CartoesModel {
  double total;
  final int cartoesDeletados;
  final int cartoesVinculados;
  final int cartoesCorrigidos;
  final int cartoesInseridos;

  CartoesModel({
    this.total = 0.0,
    required this.cartoesDeletados,
    required this.cartoesVinculados,
    required this.cartoesCorrigidos,
    required this.cartoesInseridos,
  });

  factory CartoesModel.fromMap(Map<String, dynamic> map) {
    return CartoesModel(
      cartoesDeletados: map['cartoesDeletados'] ?? 0,
      cartoesVinculados: map['cartoesVinculados'] ?? 0,
      cartoesCorrigidos: map['cartoesCorrigidos'] ?? 0,
      cartoesInseridos: map['cartoesInseridos'] ?? 0,
    );
  }

  factory CartoesModel.empty() {
    return CartoesModel(
      total: 0.0,
      cartoesDeletados: 0,
      cartoesVinculados: 0,
      cartoesCorrigidos: 0,
      cartoesInseridos: 0,
    );
  }
}
