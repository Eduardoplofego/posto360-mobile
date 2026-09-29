import 'dart:developer';

import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/core/domain/rest_client/api_routes/api_routes.dart';
import 'package:posto360/modules/core/domain/rest_client/posto_rest_client.dart';
import 'package:posto360/modules/questionario/domain/models/correcao_model.dart';
import 'package:posto360/modules/questionario/domain/models/questionario_model.dart';

import '../../domain/repositories/questionario_repository.dart';

class QuestionarioRepositoryImpl extends QuestionarioRepository {
  final PostoRestClient _postoRestClient;

  QuestionarioRepositoryImpl({required PostoRestClient postoRestClient})
    : _postoRestClient = postoRestClient;

  @override
  Future<ResultActionDTO<QuestionarioModel>> getQuestionario({
    required String usuarioId,
    required int cursoId,
  }) async {
    try {
      final result = await _postoRestClient.post(ApiRoutes.questionario(), {
        'usuarioId': usuarioId,
        'cursoId': cursoId,
      });

      if (result.statusCode == null || result.statusCode! >= 400) {
        final message =
            (result.body is Map ? result.body['message'] : null) as String? ??
            'Não foi possível carregar a prova';
        return ResultActionDTO.failure(message, null);
      }

      final questionario = QuestionarioModel.fromMap(
        Map<String, dynamic>.from(result.body),
      );
      return ResultActionDTO.success(data: questionario);
    } catch (e, s) {
      log('Erro ao buscar questionário', error: e, stackTrace: s);
      return ResultActionDTO.failure('Não foi possível carregar a prova', null);
    }
  }

  @override
  Future<ResultActionDTO<CorrecaoModel>> responderQuestionario({
    required String usuarioId,
    required int cursoId,
    required Map<int, int> respostas,
  }) async {
    try {
      final result = await _postoRestClient.post(
        ApiRoutes.questionarioResponder(),
        {
          'usuarioId': usuarioId,
          'cursoId': cursoId,
          'respostas':
              respostas.entries
                  .map(
                    (e) => {'questaoId': e.key, 'alternativaId': e.value},
                  )
                  .toList(),
        },
      );

      if (result.statusCode == null || result.statusCode! >= 400) {
        final message =
            (result.body is Map ? result.body['message'] : null) as String? ??
            'Não foi possível enviar as respostas';
        return ResultActionDTO.failure(message, null);
      }

      final correcao = CorrecaoModel.fromMap(
        Map<String, dynamic>.from(result.body),
      );
      return ResultActionDTO.success(data: correcao);
    } catch (e, s) {
      log('Erro ao responder questionário', error: e, stackTrace: s);
      return ResultActionDTO.failure(
        'Não foi possível enviar as respostas',
        null,
      );
    }
  }
}
