import 'dart:developer';

import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/core/domain/rest_client/api_routes/api_routes.dart';
import 'package:posto360/modules/core/domain/rest_client/posto_rest_client.dart';
import 'package:posto360/modules/aulas/domain/models/curso_model.dart';
import 'package:posto360/modules/core/domain/utils/status_text.dart';

import '../../domain/repositories/cursos_repository.dart';

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

      final body = result.body;
      log('Iniciar curso [${result.statusCode}]: $body');

      final resultMessage =
          body is Map ? body['message']?.toString() : body?.toString();
      final mensagemNormalizada = StatusText.normalize(resultMessage);

      // A API responde "o curso já foi iniciado" quando o vínculo existe:
      // isso não é erro, o usuário só precisa entrar no curso.
      final jaIniciado =
          mensagemNormalizada.contains('iniciado') ||
          mensagemNormalizada.contains('andamento');

      if ((result.statusCode ?? 0) < 400 && jaIniciado) {
        return ResultActionDTO.success(data: true);
      }

      return ResultActionDTO.failure(
        resultMessage?.isNotEmpty == true
            ? resultMessage!
            : 'Não foi possível iniciar o curso',
        false,
      );
    } catch (e, s) {
      log('Erro iniciar curso', error: e, stackTrace: s);
      return ResultActionDTO.failure('Não foi possível iniciar o curso', false);
    }
  }
}
