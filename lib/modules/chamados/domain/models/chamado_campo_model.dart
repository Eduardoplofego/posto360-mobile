import 'package:posto360/modules/chamados/domain/models/chamado_campo_foto_model.dart';
import 'package:posto360/modules/chamados/domain/models/chamado_tanque_model.dart';

enum ChamadoCampoTipo { text, number, boolean, select, photo, tanques, unknown }

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
    case 'tanques':
      return ChamadoCampoTipo.tanques;
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

  /// Tanques da filial do chamado. So vem preenchido em campo tipo `tanques`.
  final List<ChamadoTanqueModel> tanques;

  /// Litros ja lancados por tanque, indexados pelo `tanqueId`.
  final Map<String, double> litrosPorTanque;

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
    required this.tanques,
    required this.litrosPorTanque,
  });

  bool get hasResposta {
    if (tipo == ChamadoCampoTipo.photo) return fotos.isNotEmpty;
    if (tipo == ChamadoCampoTipo.tanques) return litrosPorTanque.isNotEmpty;
    return (valorTexto ?? '').trim().isNotEmpty;
  }

  factory ChamadoCampoModel.fromMap(Map<String, dynamic> map) {
    final tipoRaw = (map['tipo'] ?? '').toString();
    final tipo = _parseTipo(tipoRaw);

    // `valorJson` carrega coisas diferentes conforme o tipo: fotos no campo de
    // foto, litros por tanque no campo de tanques.
    final rawJson = map['valorJson'];
    final fotos = <ChamadoCampoFotoModel>[];
    final litrosPorTanque = <String, double>{};
    if (rawJson is List) {
      for (final item in rawJson) {
        if (item is! Map<String, dynamic>) continue;
        if (tipo == ChamadoCampoTipo.tanques) {
          final tanqueId = (item['tanqueId'] ?? '').toString();
          final litros = (item['litros'] as num?)?.toDouble();
          if (tanqueId.isNotEmpty && litros != null) {
            litrosPorTanque[tanqueId] = litros;
          }
        } else {
          fotos.add(ChamadoCampoFotoModel.fromMap(item));
        }
      }
    }

    final rawTanques = map['tanques'];
    final tanques = rawTanques is List
        ? rawTanques
              .whereType<Map<String, dynamic>>()
              .map(ChamadoTanqueModel.fromMap)
              .toList()
        : <ChamadoTanqueModel>[];

    final rawOpcoes = map['opcoes'];
    final opcoes = rawOpcoes is List
        ? rawOpcoes.map((o) => o.toString()).toList()
        : <String>[];

    return ChamadoCampoModel(
      id: (map['id'] as num?)?.toInt() ?? 0,
      descricao: map['descricao'] ?? '',
      valorTexto: map['valorTexto']?.toString(),
      fotos: fotos,
      opcoes: opcoes,
      obrigatorio: map['obrigatorio'] == true,
      ordem: (map['ordem'] as num?)?.toInt() ?? 0,
      placeholder: map['placeholder']?.toString(),
      tipo: tipo,
      tipoRaw: tipoRaw,
      tanques: tanques,
      litrosPorTanque: litrosPorTanque,
    );
  }
}
