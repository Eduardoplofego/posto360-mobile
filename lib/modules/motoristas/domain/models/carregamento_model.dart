import 'package:posto360/modules/motoristas/domain/models/pedido_carregamento_model.dart';

class CarregamentoModel {
  final int id;
  final DateTime dataPedido;
  final DateTime dataCarregamento;
  final String? horarioPrevisto;
  final List<PedidoCarregamentoModel> pedidos;

  CarregamentoModel({
    required this.id,
    required this.dataPedido,
    required this.dataCarregamento,
    required this.horarioPrevisto,
    required this.pedidos,
  });

  double get volumeTotal =>
      pedidos.fold<double>(0, (sum, pedido) => sum + pedido.volume);

  factory CarregamentoModel.fromMap(Map<String, dynamic> map) {
    final pedidosRaw = (map['pedidos'] as List?) ?? const [];
    return CarregamentoModel(
      id: map['id'] as int,
      dataPedido: DateTime.parse(map['dataPedido'] as String).toLocal(),
      dataCarregamento:
          DateTime.parse(map['dataCarregamento'] as String).toLocal(),
      horarioPrevisto: map['horarioPrevisto'] as String?,
      pedidos: pedidosRaw
          .map((p) => PedidoCarregamentoModel.fromMap(p as Map<String, dynamic>))
          .toList(),
    );
  }
}
