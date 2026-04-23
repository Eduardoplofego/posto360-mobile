import 'package:posto360/modules/procedimentos/domain/models/etapa_model.dart';

class ProcedimentoModel {
  final int id;
  final String nome;
  final String descricao;
  final DateTime? createdAt;
  final List<EtapaModel> etapas;

  ProcedimentoModel({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.createdAt,
    required this.etapas,
  });

  factory ProcedimentoModel.fromMap(Map<String, dynamic> map) {
    final rawEtapas = (map['etapas'] as List?) ?? [];
    final etapas =
        rawEtapas
            .map((e) => EtapaModel.fromMap(e as Map<String, dynamic>))
            .toList()
          ..sort((a, b) => a.ordem.compareTo(b.ordem));
    return ProcedimentoModel(
      id: map['id']?.toInt() ?? 0,
      nome: map['Nome'] ?? '',
      descricao: map['Descricao'] ?? '',
      createdAt:
          map['created_at'] != null
              ? DateTime.tryParse(map['created_at'].toString())
              : null,
      etapas: etapas,
    );
  }
}
