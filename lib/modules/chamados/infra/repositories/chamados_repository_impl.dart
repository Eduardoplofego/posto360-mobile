import 'dart:developer';

import 'package:posto360/modules/chamados/domain/models/chamado_campo_model.dart';
import 'package:posto360/modules/chamados/domain/models/chamado_model.dart';
import 'package:posto360/modules/chamados/domain/models/chamado_template_model.dart';
import 'package:posto360/modules/chamados/domain/repositories/chamados_repository.dart';
import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/core/domain/rest_client/api_routes/api_routes.dart';
import 'package:posto360/modules/core/domain/rest_client/posto_rest_client.dart';

class ChamadosRepositoryImpl extends ChamadosRepository {
  final PostoRestClient _postoRestClient;

  ChamadosRepositoryImpl({required PostoRestClient postoRestClient})
    : _postoRestClient = postoRestClient;

  @override
  Future<ResultActionDTO<List<ChamadoModel>>> getChamadosAbertos({
    required int filialId,
    required int empresaId,
  }) async {
    try {
      final result = await _postoRestClient.post(
        ApiRoutes.chamadosAbertos(),
        {'filialId': filialId, 'empresaId': empresaId},
      );
      final raw = result.body as List?;
      final chamados =
          raw
              ?.map<ChamadoModel>(
                (c) => ChamadoModel.fromMap(c as Map<String, dynamic>),
              )
              .toList() ??
          [];
      return ResultActionDTO.success(data: chamados);
    } catch (e, s) {
      log('Erro get chamados abertos', error: e, stackTrace: s);
      return ResultActionDTO.failure('Erro ao buscar chamados', []);
    }
  }

  @override
  Future<ResultActionDTO<List<ChamadoCampoModel>>> getCamposChamado({
    required int chamadoId,
  }) async {
    try {
      final result = await _postoRestClient.post(
        ApiRoutes.chamadosCampos(),
        {'chamadoId': chamadoId},
      );
      final raw = result.body as List?;
      final campos =
          raw
              ?.map<ChamadoCampoModel>(
                (c) => ChamadoCampoModel.fromMap(c as Map<String, dynamic>),
              )
              .toList() ??
          [];
      campos.sort((a, b) => a.ordem.compareTo(b.ordem));
      return ResultActionDTO.success(data: campos);
    } catch (e, s) {
      log('Erro get campos chamado', error: e, stackTrace: s);
      return ResultActionDTO.failure(
        'Erro ao buscar campos do chamado',
        [],
      );
    }
  }

  @override
  Future<ResultActionDTO<List<ChamadoTemplateModel>>> getTemplatesAbrirChamado({
    required int empresaId,
  }) async {
    try {
      final result = await _postoRestClient.post(
        ApiRoutes.chamadosDadosAbrir(),
        {'empresaId': empresaId},
      );
      final status = result.statusCode;
      final body = result.body;
      if (status == null || status < 200 || status >= 300) {
        return ResultActionDTO.failure(
          'Erro ${status ?? ''} ao buscar templates'.trim(),
          [],
        );
      }
      if (body is! Map) {
        return ResultActionDTO.failure('Resposta inválida do servidor', []);
      }
      final rawTemplates = body['templates'];
      if (rawTemplates is! List) {
        return ResultActionDTO.success(data: []);
      }
      final templates = rawTemplates
          .whereType<Map>()
          .map(
            (t) => ChamadoTemplateModel.fromMap(Map<String, dynamic>.from(t)),
          )
          .toList();
      return ResultActionDTO.success(data: templates);
    } catch (e, s) {
      log('Erro get templates abrir chamado', error: e, stackTrace: s);
      return ResultActionDTO.failure(
        'Erro ao buscar templates: ${e.toString()}',
        [],
      );
    }
  }

  @override
  Future<ResultActionDTO<int?>> abrirChamado({
    required int templateId,
    required String abertoPor,
    required String titulo,
    required int filialId,
    required int empresaId,
  }) async {
    try {
      final result = await _postoRestClient.post(ApiRoutes.chamadosAbrir(), {
        'templateId': templateId,
        'abertoPor': abertoPor,
        'titulo': titulo,
        'filialId': filialId,
        'empresaId': empresaId,
      });
      final status = result.statusCode;
      if (status == null || status < 200 || status >= 300) {
        return ResultActionDTO.failure(
          'Erro ${status ?? ''} ao abrir chamado'.trim(),
          null,
        );
      }
      return ResultActionDTO.success(data: _extrairChamadoId(result.body));
    } catch (e, s) {
      log('Erro abrir chamado', error: e, stackTrace: s);
      return ResultActionDTO.failure(
        'Erro ao abrir chamado: ${e.toString()}',
        null,
      );
    }
  }

  @override
  Future<ResultActionDTO<bool>> atualizarCampos({
    required int chamadoId,
    required List<Map<String, dynamic>> campos,
  }) async {
    try {
      final result = await _postoRestClient.post(
        ApiRoutes.chamadosAtualizarCampos(),
        {'chamadoId': chamadoId, 'campos': campos},
      );
      final status = result.statusCode;
      if (status == null || status < 200 || status >= 300) {
        return ResultActionDTO.failure(
          'Erro ${status ?? ''} ao atualizar campos: ${result.statusText ?? ''}'
              .trim(),
          false,
        );
      }
      return ResultActionDTO.success(data: true);
    } catch (e, s) {
      log('Erro atualizar campos chamado', error: e, stackTrace: s);
      return ResultActionDTO.failure(
        'Erro ao atualizar campos: ${e.toString()}',
        false,
      );
    }
  }

  int? _extrairChamadoId(dynamic body) {
    int? toInt(dynamic v) {
      if (v == null) return null;
      if (v is int) return v;
      if (v is num) return v.toInt();
      if (v is String) return int.tryParse(v);
      return null;
    }

    if (body is num) return body.toInt();
    if (body is String) return int.tryParse(body);
    if (body is Map) {
      for (final key in const ['id', 'chamadoId', 'Id', 'ID']) {
        final v = body[key];
        final parsed = toInt(v);
        if (parsed != null) return parsed;
      }
      for (final wrapKey in const ['chamado', 'data', 'result']) {
        final inner = body[wrapKey];
        if (inner is Map) {
          for (final key in const ['id', 'chamadoId', 'Id', 'ID']) {
            final parsed = toInt(inner[key]);
            if (parsed != null) return parsed;
          }
        }
      }
    }
    return null;
  }
}
