import 'dart:convert';

class ProdutoModel {
  final int idProduto;
  final String nomeProduto;
  final int codigoProduto;
  ProdutoModel({
    required this.idProduto,
    required this.nomeProduto,
    required this.codigoProduto,
  });

  Map<String, dynamic> toMap() {
    return {
      'idProduto': idProduto,
      'nomeProduto': nomeProduto,
      'codigoProduto': codigoProduto,
    };
  }

  factory ProdutoModel.fromMap(Map<String, dynamic> map) {
    return ProdutoModel(
      idProduto: map['id']?.toInt() ?? 0,
      nomeProduto: map['produtoNome'] ?? '',
      codigoProduto: map['produtoCodigo']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory ProdutoModel.fromJson(String source) =>
      ProdutoModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'ProdutoModel(idProduto: $idProduto, nomeProduto: $nomeProduto, codigoProduto: $codigoProduto)';
}
