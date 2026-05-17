class PedidoCarregamentoModel {
  final int id;
  final String produtoNome;
  final double volume;

  PedidoCarregamentoModel({
    required this.id,
    required this.produtoNome,
    required this.volume,
  });

  factory PedidoCarregamentoModel.fromMap(Map<String, dynamic> map) {
    final volumeNum = map['volume'] as num? ?? 0;
    return PedidoCarregamentoModel(
      id: map['id'] as int,
      produtoNome: map['produtoNome'] as String? ?? '',
      volume: volumeNum.toDouble(),
    );
  }
}
