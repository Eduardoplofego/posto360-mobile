import 'dart:convert';

/// Como a divergencia de cartao foi resolvida.
enum StatusCartao {
  vinculado('Vinculado'),
  corrigido('Corrigido'),
  deletado('Deletado'),
  inserido('Inserido'),
  desconhecido('');

  final String valor;
  const StatusCartao(this.valor);

  static StatusCartao fromValor(String? valor) {
    if (valor == null) return StatusCartao.desconhecido;
    return StatusCartao.values.firstWhere(
      (status) => status.valor.toLowerCase() == valor.toLowerCase(),
      orElse: () => StatusCartao.desconhecido,
    );
  }
}

extension StatusCartaoLabelExt on StatusCartao {
  String label(String? bruto) {
    if (this == StatusCartao.desconhecido) {
      return (bruto == null || bruto.isEmpty) ? 'Sem status' : bruto;
    }
    return valor;
  }

  String get descricao {
    switch (this) {
      case StatusCartao.vinculado:
        return 'Transação do PDV vinculada à autorização da adquirente';
      case StatusCartao.corrigido:
        return 'Registro do PDV apagado ou divergência de valor/bandeira resolvida';
      case StatusCartao.deletado:
        return 'Não existia na adquirente e foi removido do PDV';
      case StatusCartao.inserido:
        return 'Não existia no PDV e passou a existir';
      case StatusCartao.desconhecido:
        return '';
    }
  }
}

/// Um lado da comparacao: como o cartao estava no PDV (`antigo`) ou como ficou
/// depois da correcao (`correto`). Todos os campos podem vir nulos.
class CartaoSnapshotModel {
  final String? autorizacao;
  final String? bandeira;
  final DateTime? vencimento;
  final double? valorBruto;

  const CartaoSnapshotModel({
    this.autorizacao,
    this.bandeira,
    this.vencimento,
    this.valorBruto,
  });

  bool get isVazio =>
      autorizacao == null &&
      bandeira == null &&
      vencimento == null &&
      valorBruto == null;

  factory CartaoSnapshotModel.fromMap(Map<String, dynamic>? map) {
    if (map == null) return const CartaoSnapshotModel();
    return CartaoSnapshotModel(
      autorizacao: _textoOuNulo(map['autorizacao']),
      bandeira: _textoOuNulo(map['bandeira']),
      vencimento: _dataOuNulo(map['vencimento']),
      valorBruto: (map['valorBruto'] as num?)?.toDouble(),
    );
  }
}

class CartaoDiscrepanciaModel {
  final int id;
  final double valorBruto;
  final StatusCartao status;
  final String statusBruto;
  final List<String> tipos;
  final CartaoSnapshotModel antigo;
  final CartaoSnapshotModel correto;

  const CartaoDiscrepanciaModel({
    required this.id,
    required this.valorBruto,
    required this.status,
    required this.statusBruto,
    required this.tipos,
    required this.antigo,
    required this.correto,
  });

  String get statusLabel => status.label(statusBruto);

  /// A API so preenche `correto` em parte dos casos (`AutorizacaoCorreta` so na
  /// vinculacao, os demais campos so quando a conciliacao os gravou).
  bool get hasCorrecao => !correto.isVazio;

  factory CartaoDiscrepanciaModel.fromMap(Map<String, dynamic> map) {
    final statusBruto = _textoOuNulo(map['status']) ?? '';
    return CartaoDiscrepanciaModel(
      id: (map['id'] as num?)?.toInt() ?? 0,
      valorBruto: (map['valorBruto'] as num?)?.toDouble() ?? 0.0,
      status: StatusCartao.fromValor(statusBruto),
      statusBruto: statusBruto,
      tipos: parseTipos(map['tipo']),
      antigo: CartaoSnapshotModel.fromMap(
        map['antigo'] as Map<String, dynamic>?,
      ),
      correto: CartaoSnapshotModel.fromMap(
        map['correto'] as Map<String, dynamic>?,
      ),
    );
  }

  /// `tipo` vem cru do banco e tem mais de um formato: JSON (`'["Valor errado"]'`),
  /// array do Postgres (`'{"Valor errado"}'`) ou a string solta.
  static List<String> parseTipos(dynamic bruto) {
    if (bruto == null) return [];

    if (bruto is List) return _limpar(bruto.map((e) => e.toString()));

    final texto = bruto.toString().trim();
    if (texto.isEmpty) return [];

    try {
      final decodificado = jsonDecode(texto);
      if (decodificado is List) {
        return _limpar(decodificado.map((e) => e.toString()));
      }
      if (decodificado is String) return _limpar([decodificado]);
    } catch (_) {
      // Nao era JSON: cai para os formatos abaixo.
    }

    final isDelimitado =
        (texto.startsWith('{') && texto.endsWith('}')) ||
        (texto.startsWith('[') && texto.endsWith(']'));

    if (isDelimitado) {
      final interno = texto.substring(1, texto.length - 1);
      return _limpar(interno.split(','));
    }

    return _limpar([texto]);
  }

  static List<String> _limpar(Iterable<String> valores) {
    return valores
        .map((e) => e.trim().replaceAll(RegExp(r'^"+|"+$'), '').trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }
}

String? _textoOuNulo(dynamic valor) {
  if (valor == null) return null;
  final texto = valor.toString().trim();
  return texto.isEmpty ? null : texto;
}

DateTime? _dataOuNulo(dynamic valor) {
  final texto = _textoOuNulo(valor);
  if (texto == null) return null;
  return DateTime.tryParse(texto);
}
