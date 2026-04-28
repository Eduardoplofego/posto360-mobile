import 'dart:convert';

class AvaliatorDicretionsModel {
  final int id;
  final String? dataPreenchimento;
  final bool? cumprido;
  final double penalidade;
  final String? comentarios;
  final String nome;
  final String descricao;
  final int criterioModeloId;

  AvaliatorDicretionsModel({
    required this.id,
    this.dataPreenchimento,
    this.cumprido = false,
    required this.penalidade,
    this.comentarios,
    required this.nome,
    required this.descricao,
    required this.criterioModeloId,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'dataPreenchimento': dataPreenchimento,
      'cumprido': cumprido,
      'penalidade': penalidade,
      'comentarios': comentarios,
      'nome': nome,
      'descricao': descricao,
      'criterioModeloId': criterioModeloId,
    };
  }

  factory AvaliatorDicretionsModel.fromMap(Map<String, dynamic> map) {
    return AvaliatorDicretionsModel(
      id: map['id']?.toInt() ?? 0,
      dataPreenchimento: map['dataPreenchimento'],
      cumprido: map['cumprido'],
      penalidade: (map['penalidade'] as num?)?.toDouble() ?? 0.0,
      comentarios: map['comentarios'],
      nome: map['nome'] ?? '',
      descricao: map['descricao'] ?? '',
      criterioModeloId: map['criterioModeloId']?.toInt() ?? 0,
    );
  }

  String toJson() => json.encode(toMap());

  factory AvaliatorDicretionsModel.fromJson(String source) =>
      AvaliatorDicretionsModel.fromMap(json.decode(source));

  @override
  String toString() =>
      'AvaliatorDicretionsModel(id: $id, nome: $nome, cumprido: $cumprido)';
}
