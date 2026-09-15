/// Codigo curto do produto, que e como o motorista se refere ao combustivel.
/// A chave e o nome cadastrado em tanques.TanquesFiliais, normalizado.
const _codigosProduto = <String, String>{
  'gasolina comum': 'GC',
  'gasolina aditivada': 'GA',
  'diesel s10': 'S10',
  'diesel s500': 'S500',
  'etanol': 'ET',
};

/// Ordem em que os codigos aparecem no filtro. Produto fora dessa lista entra
/// depois, com o proprio nome cadastrado, para nunca sumir da tela por falta
/// de traducao.
const ordemCodigosProduto = <String>['GC', 'GA', 'S10', 'S500', 'ET'];

/// Um tanque da filial do chamado, usado pelo campo de tipo `tanques`.
///
/// Vem da API junto com o campo, porque a mesma filial costuma ter mais de um
/// tanque do mesmo produto (a filial 1 tem tres Diesel S10), entao o produto
/// sozinho nao identifica onde a carga foi descarregada.
class ChamadoTanqueModel {
  final String tanqueId;
  final String produto;
  final double? capacidade;

  ChamadoTanqueModel({
    required this.tanqueId,
    required this.produto,
    required this.capacidade,
  });

  String get produtoCodigo {
    final chave = produto.trim().toLowerCase().replaceAll(RegExp(r'\s+'), ' ');
    return _codigosProduto[chave] ?? produto.trim();
  }

  factory ChamadoTanqueModel.fromMap(Map<String, dynamic> map) {
    return ChamadoTanqueModel(
      tanqueId: (map['tanqueId'] ?? '').toString(),
      produto: (map['produto'] ?? '').toString(),
      capacidade: (map['capacidade'] as num?)?.toDouble(),
    );
  }
}
