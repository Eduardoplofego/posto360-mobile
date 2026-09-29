import 'dart:convert';

import 'package:posto360/modules/aulas/domain/models/curso_procedimento_model.dart';
import 'package:posto360/modules/core/domain/utils/enums/curso_status.dart';

class CursoModel {
  final int id;
  final int templateId;
  final String titulo;
  final String descricao;
  final String capa;
  final CursoStatus status;
  final int totalAulas;
  final int aulasConcluidas;

  /// Quando o curso foi atribuído ao usuário.
  final DateTime inscricao;

  /// Quando o usuário começou de fato. `null` até ele iniciar o curso.
  final DateTime? inicio;

  final DateTime? ultimoAcesso;

  /// Prazo final de validade: é por ele que o job de penalidades cobra.
  final DateTime? prazoFinal;

  /// Procedimentos da empresa vinculados ao curso.
  final List<CursoProcedimentoModel> procedimentos;

  /// Validade da conclusão: quando o curso já concluído vence e precisa ser
  /// refeito (ex: NR20 vence a cada 3 anos). Não confundir com [prazoFinal],
  /// que é o prazo para concluir o curso, não para ele vencer depois de
  /// concluído.
  final CursoValidadeConclusaoModel validadeConclusao;

  /// PDF do certificado. Pode não existir mesmo com o curso concluído, se o
  /// curso não tiver certificado configurado.
  final CursoDocumentoModel certificado;

  bool get certificadoEmitido => certificado.emitido;

  CursoModel({
    required this.id,
    required this.templateId,
    required this.titulo,
    required this.descricao,
    required this.capa,
    required this.status,
    required this.totalAulas,
    required this.aulasConcluidas,
    required this.inscricao,
    required this.inicio,
    required this.ultimoAcesso,
    required this.prazoFinal,
    required this.procedimentos,
    required this.validadeConclusao,
    required this.certificado,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'templateId': templateId,
      'titulo': titulo,
      'descricao': descricao,
      'url': capa,
      'status': status.description(),
    };
  }

  static DateTime? _parseData(dynamic valor) {
    if (valor == null) return null;
    return DateTime.tryParse(valor.toString());
  }

  factory CursoModel.fromMap(Map<String, dynamic> map) {
    return CursoModel(
      id: map['id'] ?? 0,
      templateId: map['templateId'] ?? 0,
      titulo: map['titulo'] ?? '',
      descricao: map['descricao'] ?? '',
      capa: map['capa'] ?? '',
      status: GetCursoStatus.getStatus(map['status']),
      aulasConcluidas: map['aulasConcluidas'] ?? 0,
      totalAulas: map['totalAulas'] ?? 0,
      // 'dataInicio' é o nome legado da data de atribuição: continua vindo da
      // API com esse valor para não quebrar versões antigas do app
      inscricao:
          _parseData(map['dataAtribuicao'] ?? map['dataInicio']) ??
          DateTime(1900),
      inicio: _parseData(map['iniciadoEm']),
      // a API manda os dois nomes; 'ultimoAcesso' é alias temporário
      ultimoAcesso: _parseData(
        map['dataUltimoAcesso'] ?? map['ultimoAcesso'],
      ),
      prazoFinal: _parseData(map['dataValidadeFim']),
      procedimentos:
          (map['procedimentos'] as List?)
              ?.map(
                (p) => CursoProcedimentoModel.fromMap(
                  Map<String, dynamic>.from(p),
                ),
              )
              .toList() ??
          [],
      validadeConclusao: CursoValidadeConclusaoModel.fromMap(
        map['validadeConclusao'],
      ),
      certificado: CursoDocumentoModel.fromMap(map['certificado']),
    );
  }

  String toJson() => json.encode(toMap());

  factory CursoModel.fromJson(String source) =>
      CursoModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'CursoModel(id: $id, templateId: $templateId, titulo: $titulo, descricao: $descricao, capa: $capa, status: $status, totalAulas: $totalAulas, aulasConcluidas: $aulasConcluidas, inscricao: $inscricao, inicio: $inicio, ultimoAcesso: $ultimoAcesso, prazoFinal: $prazoFinal, procedimentos: $procedimentos, validadeConclusao: $validadeConclusao, certificado: $certificado)';
  }
}

/// Situação de vencimento da conclusão de um curso já concluído.
enum CursoValidadeSituacao { vencido, venceEmBreve }

class CursoValidadeConclusaoModel {
  final DateTime? dataVencimento;
  final CursoValidadeSituacao? situacao;

  const CursoValidadeConclusaoModel({this.dataVencimento, this.situacao});

  bool get vencido => situacao == CursoValidadeSituacao.vencido;
  bool get venceEmBreve => situacao == CursoValidadeSituacao.venceEmBreve;

  static DateTime? _parseData(dynamic valor) {
    if (valor == null) return null;
    return DateTime.tryParse(valor.toString());
  }

  static CursoValidadeSituacao? _parseSituacao(dynamic valor) {
    switch (valor) {
      case 'Vencido':
        return CursoValidadeSituacao.vencido;
      case 'Vence em breve':
        return CursoValidadeSituacao.venceEmBreve;
      default:
        return null;
    }
  }

  factory CursoValidadeConclusaoModel.fromMap(dynamic map) {
    if (map is! Map) return const CursoValidadeConclusaoModel();
    return CursoValidadeConclusaoModel(
      dataVencimento: _parseData(map['dataVencimento']),
      situacao: _parseSituacao(map['situacao']),
    );
  }

  @override
  String toString() =>
      'CursoValidadeConclusaoModel(dataVencimento: $dataVencimento, situacao: $situacao)';
}

/// Certificado (PDF) gerado automaticamente pelo backend quando o
/// colaborador termina o curso. `url` só existe quando `emitido` é true.
class CursoDocumentoModel {
  final bool emitido;
  final String? url;

  const CursoDocumentoModel({required this.emitido, this.url});

  factory CursoDocumentoModel.fromMap(dynamic map) {
    if (map is! Map) return const CursoDocumentoModel(emitido: false);
    return CursoDocumentoModel(
      emitido: map['emitido'] ?? false,
      url: map['url'] as String?,
    );
  }

  @override
  String toString() => 'CursoDocumentoModel(emitido: $emitido, url: $url)';
}
