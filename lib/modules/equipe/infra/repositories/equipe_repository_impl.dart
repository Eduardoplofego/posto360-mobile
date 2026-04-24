import 'dart:developer';

import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/core/domain/models/user_model.dart';
import 'package:posto360/modules/core/domain/rest_client/api_routes/api_routes.dart';
import 'package:posto360/modules/core/domain/rest_client/posto_rest_client.dart';
import 'package:posto360/modules/equipe/domain/models/membro_equipe_model.dart';
import 'package:posto360/modules/equipe/domain/models/resumo_equipe_model.dart';
import 'package:posto360/modules/equipe/domain/repositories/equipe_repository.dart';

class EquipeRepositoryImpl extends EquipeRepository {
  final PostoRestClient _postoRestClient;

  EquipeRepositoryImpl({required PostoRestClient postoRestClient})
    : _postoRestClient = postoRestClient;

  @override
  Future<ResultActionDTO<ResumoEquipeModel>> getResumo({
    required String dataInicial,
    required String dataFinal,
    required int filialId,
  }) async {
    try {
      final result = await _postoRestClient.post(
        ApiRoutes.gerentesDashboardEquipe(),
        {
          'dataInicial': dataInicial,
          'dataFinal': dataFinal,
          'filialId': filialId,
        },
      );
      if (result.statusCode != null && result.statusCode! >= 400) {
        log(
          'Erro get resumo equipe [${result.statusCode}]',
          error: result.bodyString,
          stackTrace: StackTrace.current,
        );
        return ResultActionDTO.failure(
          'Erro ao buscar resumo da equipe',
          ResumoEquipeModel.empty(),
        );
      }
      final body = result.body;
      if (body is! Map<String, dynamic>) {
        log(
          'Resposta inesperada get resumo equipe',
          error: result.bodyString,
          stackTrace: StackTrace.current,
        );
        return ResultActionDTO.failure(
          'Resposta inesperada do servidor',
          ResumoEquipeModel.empty(),
        );
      }
      return ResultActionDTO.success(data: ResumoEquipeModel.fromMap(body));
    } catch (e, s) {
      log('Erro get resumo equipe', error: e, stackTrace: s);
      return ResultActionDTO.failure(
        'Erro ao buscar resumo da equipe',
        ResumoEquipeModel.empty(),
      );
    }
  }

  @override
  Future<ResultActionDTO<List<MembroEquipeModel>>> getMembros({
    required String dataInicial,
    required String dataFinal,
    required int filialId,
  }) async {
    try {
      final result = await _postoRestClient.post(
        ApiRoutes.gerentesEquipeDetalhes(),
        {
          'dataInicial': dataInicial,
          'dataFinal': dataFinal,
          'filialId': filialId,
        },
      );
      if (result.statusCode != null && result.statusCode! >= 400) {
        log(
          'Erro get membros equipe [${result.statusCode}]',
          error: result.bodyString,
          stackTrace: StackTrace.current,
        );
        return ResultActionDTO.failure('Erro ao buscar equipe', []);
      }
      final raw = result.body;
      if (raw is! List) {
        log(
          'Resposta inesperada get membros equipe',
          error: result.bodyString,
          stackTrace: StackTrace.current,
        );
        return ResultActionDTO.failure('Resposta inesperada do servidor', []);
      }
      final membros = raw
          .map<MembroEquipeModel>(
            (m) => MembroEquipeModel.fromMap(m as Map<String, dynamic>),
          )
          .toList();
      return ResultActionDTO.success(data: membros);
    } catch (e, s) {
      log('Erro get membros equipe', error: e, stackTrace: s);
      return ResultActionDTO.failure('Erro ao buscar equipe', []);
    }
  }

  @override
  Future<ResultActionDTO<UserModel>> getColaborador({
    required String id,
  }) async {
    try {
      final result = await _postoRestClient.post(
        ApiRoutes.gerentesEquipeColaborador(),
        {'id': id},
      );
      final body = result.body as Map<String, dynamic>;
      final userData = body['userData'] as Map<String, dynamic>;
      return ResultActionDTO.success(data: UserModel.fromMap(userData));
    } catch (e, s) {
      log('Erro get colaborador', error: e, stackTrace: s);
      return ResultActionDTO.failure(
        'Erro ao buscar dados do colaborador',
        UserModel.empty(),
      );
    }
  }
}
