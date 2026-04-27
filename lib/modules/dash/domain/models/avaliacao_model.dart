class AvaliacaoModel {
  final int total;
  final int feitas;
  final double penalidade;

  AvaliacaoModel({
    required this.total,
    required this.feitas,
    required this.penalidade,
  });

  factory AvaliacaoModel.empty() {
    return AvaliacaoModel(total: 0, feitas: 0, penalidade: 0);
  }
}
