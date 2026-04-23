import 'package:posto360/modules/procedimentos/domain/models/passo_model.dart';

class EtapaModel {
  final int id;
  final String titulo;
  final int ordem;
  final int procedimentoId;
  final List<PassoModel> passos;

  EtapaModel({
    required this.id,
    required this.titulo,
    required this.ordem,
    required this.procedimentoId,
    required this.passos,
  });

  factory EtapaModel.fromMap(Map<String, dynamic> map) {
    final rawPassos = (map['passos'] as List?) ?? [];
    final passos =
        rawPassos
            .map((p) => PassoModel.fromMap(p as Map<String, dynamic>))
            .toList()
          ..sort((a, b) => a.ordem.compareTo(b.ordem));
    return EtapaModel(
      id: map['id']?.toInt() ?? 0,
      titulo: (map['Titulo'] ?? '').toString().trim(),
      ordem: map['Ordem']?.toInt() ?? 0,
      procedimentoId: map['ProcedimentoId']?.toInt() ?? 0,
      passos: passos,
    );
  }
}
