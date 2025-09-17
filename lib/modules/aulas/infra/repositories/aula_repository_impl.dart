import 'dart:developer';

import 'package:posto360/core/dto/result_action_dto.dart';
import 'package:posto360/core/rest_client/api_routes/api_routes.dart';
import 'package:posto360/core/rest_client/posto_rest_client.dart';

import 'package:posto360/models/aula_model.dart';

import '../../domain/repositories/aula_repository.dart';

class AulaRepositoryImpl extends AulaRepository {
  final PostoRestClient _restClient;

  AulaRepositoryImpl({required PostoRestClient restClient})
    : _restClient = restClient;

  @override
  Future<ResultActionDTO<List<AulaModel>>> getAulas({
    required int cursoId,
    required String usuarioId,
  }) async {
    try {
      final result = await _restClient.post(ApiRoutes.aulas(), {
        'cursoId': cursoId,
        'usuarioId': usuarioId,
      });
      if (result.statusCode! >= 400) {
        return ResultActionDTO.failure(
          'Não foi possível buscar as aulas deste curso.',
          [],
        );
      }
      final aulasList =
          result.body
              .map<AulaModel>((aula) => AulaModel.fromMap(aula))
              .toList() ??
          [];
      return ResultActionDTO.success(data: aulasList);
      // return ResultActionDTO.success(data: _aulas);
    } catch (e, s) {
      log('Erro ao buscar aulas', error: e, stackTrace: s);
      return ResultActionDTO.failure('Algo deu errado', []);
    }
  }

  @override
  Future<ResultActionDTO<bool>> concludeAula({required int aulaId}) async {
    try {
      final result = await _restClient.post(ApiRoutes.aulaConcluida(), {
        'aulaId': aulaId,
      });
      if (result.statusCode != 200) {
        return ResultActionDTO.failure(
          'Não foi possível concluir a aula',
          false,
        );
      }
      return ResultActionDTO.success(data: false);
    } catch (e, s) {
      log('Erro ao visualizar aula', error: e, stackTrace: s);
      return ResultActionDTO.failure('Erro ao visualizar aula', false);
    }
  }
}
