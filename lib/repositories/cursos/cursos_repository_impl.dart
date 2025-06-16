import 'dart:developer';

import 'package:posto360/core/dto/result_action_dto.dart';
import 'package:posto360/core/rest_client/api_routes/api_routes.dart';
import 'package:posto360/core/rest_client/posto_rest_client.dart';
import 'package:posto360/models/curso_model.dart';

import './cursos_repository.dart';

class CursosRepositoryImpl extends CursosRepository {
  final PostoRestClient _restClient;

  CursosRepositoryImpl({required PostoRestClient postoRestClient})
    : _restClient = postoRestClient;

  @override
  Future<ResultActionDTO<List<CursoModel>>> getCursos({
    required String usuarioId,
  }) async {
    try {
      final response = await _restClient.post(ApiRoutes.cursos(), {
        'usuarioId': usuarioId,
      });

      final resultBody = response.body;
      final cursos =
          resultBody
              .map<CursoModel>((curso) => CursoModel.fromMap(curso))
              .toList() ??
          [];
      return ResultActionDTO.success(data: cursos);
    } catch (e, s) {
      log('Erro get cursos', error: e, stackTrace: s);
      return ResultActionDTO.failure('Não foi possível obter os cursos', []);
    }
  }

  @override
  Future<ResultActionDTO<bool>> iniciarCurso({
    required String usuarioId,
    required int cursoId,
  }) async {
    try {
      final result = await _restClient.post(ApiRoutes.iniciarCurso(), {
        'usuarioId': usuarioId,
        'cursoId': cursoId,
      });

      final resultMessage = result.body['message'] as String?;

      if (resultMessage == null) {
        return ResultActionDTO.failure(
          'Não foi possível iniciar o curso',
          false,
        );
      }

      if (resultMessage.contains('foi iniciado')) {
        return ResultActionDTO.success(data: true);
      }

      return ResultActionDTO.failure(resultMessage, false);
    } catch (e, s) {
      log('Erro iniciar curso', error: e, stackTrace: s);
      return ResultActionDTO.failure('Não foi possível iniciar o curso', false);
    }
  }
}
