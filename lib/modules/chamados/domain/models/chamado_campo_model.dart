import 'package:posto360/modules/chamados/domain/models/chamado_campo_foto_model.dart';

enum ChamadoCampoTipo { text, number, boolean, select, photo, unknown }

ChamadoCampoTipo _parseTipo(String? raw) {
  switch (raw) {
    case 'text':
      return ChamadoCampoTipo.text;
    case 'number':
      return ChamadoCampoTipo.number;
    case 'bool':
    case 'boolean':
      return ChamadoCampoTipo.boolean;
    case 'select':
      return ChamadoCampoTipo.select;
    case 'photo':
      return ChamadoCampoTipo.photo;
    default:
      return ChamadoCampoTipo.unknown;
  }
}

class ChamadoCampoModel {
  final int id;
  final String descricao;
  final String? valorTexto;
  final List<ChamadoCampoFotoModel> fotos;
  final List<String> opcoes;
  final bool obrigatorio;
  final int ordem;
  final String? placeholder;
  final ChamadoCampoTipo tipo;
  final String tipoRaw;

  ChamadoCampoModel({
    required this.id,
    required this.descricao,
    required this.valorTexto,
    required this.fotos,
    required this.opcoes,
    required this.obrigatorio,
    required this.ordem,
    required this.placeholder,
    required this.tipo,
    required this.tipoRaw,
  });

  bool get hasResposta {
    if (tipo == ChamadoCampoTipo.photo) return fotos.isNotEmpty;
    return (valorTexto ?? '').trim().isNotEmpty;
  }

  factory ChamadoCampoModel.fromMap(Map<String, dynamic> map) {
    final rawJson = map['valorJson'];
    final fotos = <ChamadoCampoFotoModel>[];
    if (rawJson is List) {
      for (final item in rawJson) {
        if (item is Map<String, dynamic>) {
          fotos.add(ChamadoCampoFotoModel.fromMap(item));
        }
      }
    }
    final rawOpcoes = map['opcoes'];
    final opcoes = rawOpcoes is List
        ? rawOpcoes.map((o) => o.toString()).toList()
        : <String>[];
    final tipoRaw = (map['tipo'] ?? '').toString();

    return ChamadoCampoModel(
      id: (map['id'] as num?)?.toInt() ?? 0,
      descricao: map['descricao'] ?? '',
      valorTexto: map['valorTexto']?.toString(),
      fotos: fotos,
      opcoes: opcoes,
      obrigatorio: map['obrigatorio'] == true,
      ordem: (map['ordem'] as num?)?.toInt() ?? 0,
      placeholder: map['placeholder']?.toString(),
      tipo: _parseTipo(tipoRaw),
      tipoRaw: tipoRaw,
    );
  }
}
