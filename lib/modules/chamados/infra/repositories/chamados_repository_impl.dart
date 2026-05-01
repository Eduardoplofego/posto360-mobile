import 'dart:convert';
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
    final url = ApiRoutes.chamadosDadosAbrir();
    final payload = {'empresaId': empresaId};
    // ignore: avoid_print
    print('[CHAMADOS] >>> POST $url');
    // ignore: avoid_print
    print('[CHAMADOS] >>> payload: $payload');
    try {
      final result = await _postoRestClient.post(url, payload);
      final status = result.statusCode;
      final body = result.body;
      // ignore: avoid_print
    print('[CHAMADOS] <<< status: $status');
      // ignore: avoid_print
    print('[CHAMADOS] <<< statusText: ${result.statusText}');
      // ignore: avoid_print
    print('[CHAMADOS] <<< body type: ${body.runtimeType}');
      // ignore: avoid_print
    print('[CHAMADOS] <<< body: $body');

      if (status == null || status < 200 || status >= 300) {
        return ResultActionDTO.failure(
          'Erro ${status ?? ''} ao buscar templates'.trim(),
          [],
        );
      }
      if (body is! Map) {
        // ignore: avoid_print
    print('[CHAMADOS] !!! body não é Map (é ${body.runtimeType})');
        return ResultActionDTO.failure('Resposta inválida do servidor', []);
      }
      final rawTemplates = body['templates'];
      // ignore: avoid_print
    print('[CHAMADOS] templates raw type: ${rawTemplates.runtimeType}');
      // ignore: avoid_print
    print('[CHAMADOS] templates raw: $rawTemplates');
      if (rawTemplates is! List) {
        return ResultActionDTO.success(data: []);
      }
      final templates = rawTemplates
          .whereType<Map>()
          .map(
            (t) => ChamadoTemplateModel.fromMap(Map<String, dynamic>.from(t)),
          )
          .toList();
      // ignore: avoid_print
    print('[CHAMADOS] parseados ${templates.length} templates');
      return ResultActionDTO.success(data: templates);
    } catch (e, s) {
      // ignore: avoid_print
    print('[CHAMADOS] !!! exception: $e');
      // ignore: avoid_print
    print('[CHAMADOS] !!! stack: $s');
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
    final url = ApiRoutes.chamadosAbrir();
    final payload = {
      'templateId': templateId,
      'abertoPor': abertoPor,
      'titulo': titulo,
      'filialId': filialId,
      'empresaId': empresaId,
    };
    // ignore: avoid_print
    print('[CHAMADOS] >>> POST $url');
    // ignore: avoid_print
    print('[CHAMADOS] >>> payload: $payload');
    try {
      final result = await _postoRestClient.post(url, payload);
      final status = result.statusCode;
      final body = result.body;
      // ignore: avoid_print
    print('[CHAMADOS] <<< status: $status');
      // ignore: avoid_print
    print('[CHAMADOS] <<< body type: ${body.runtimeType}');
      // ignore: avoid_print
    print('[CHAMADOS] <<< body: $body');
      if (status == null || status < 200 || status >= 300) {
        return ResultActionDTO.failure(
          'Erro ${status ?? ''} ao abrir chamado'.trim(),
          null,
        );
      }
      final chamadoId = _extrairChamadoId(body);
      // ignore: avoid_print
    print('[CHAMADOS] chamadoId extraído: $chamadoId');
      return ResultActionDTO.success(data: chamadoId);
    } catch (e, s) {
      // ignore: avoid_print
    print('[CHAMADOS] !!! exception abrir: $e');
      // ignore: avoid_print
    print('[CHAMADOS] !!! stack: $s');
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
    final url = ApiRoutes.chamadosAtualizarCampos();
    final body = {'chamadoId': chamadoId, 'campos': campos};

    int totalFotos = 0;
    int totalBase64Bytes = 0;
    for (final c in campos) {
      if (c['tipo'] == 'photo') {
        final entries = c['valorJson'] as List?;
        if (entries == null) continue;
        for (final e in entries) {
          if (e is Map && e['action'] == 'upload') {
            totalFotos++;
            final dados = e['dadosUpload'] as Map?;
            final b64 = dados?['base64'] as String?;
            if (b64 != null) totalBase64Bytes += b64.length;
          }
        }
      }
    }
    final payloadStr = jsonEncode(body);
    final payloadKB = (payloadStr.length / 1024).toStringAsFixed(1);
    final base64KB = (totalBase64Bytes / 1024).toStringAsFixed(1);

    // ignore: avoid_print
    print('[CHAMADOS] >>> POST $url');
    // ignore: avoid_print
    print(
      '[CHAMADOS] >>> ${campos.length} campo(s), $totalFotos foto(s) p/ upload',
    );
    // ignore: avoid_print
    print(
      '[CHAMADOS] >>> payload total: ${payloadKB}KB (base64: ${base64KB}KB)',
    );

    final stopwatch = Stopwatch()..start();
    try {
      final result = await _postoRestClient.post(url, body);
      stopwatch.stop();
      final status = result.statusCode;
      // ignore: avoid_print
    print(
        '[CHAMADOS] <<< status: $status (${stopwatch.elapsedMilliseconds}ms)',
      );
      // ignore: avoid_print
    print('[CHAMADOS] <<< statusText: ${result.statusText}');
      // ignore: avoid_print
    print('[CHAMADOS] <<< body: ${result.body}');
      if (status == null || status < 200 || status >= 300) {
        return ResultActionDTO.failure(
          'Erro ${status ?? ''} ao atualizar campos: ${result.statusText ?? ''}'
              .trim(),
          false,
        );
      }
      return ResultActionDTO.success(data: true);
    } catch (e, s) {
      stopwatch.stop();
      // ignore: avoid_print
    print(
        '[CHAMADOS] !!! exception após ${stopwatch.elapsedMilliseconds}ms: $e',
      );
      // ignore: avoid_print
    print('[CHAMADOS] !!! stack: $s');
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
