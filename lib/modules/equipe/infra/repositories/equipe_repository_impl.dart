import 'dart:developer';

import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/core/domain/models/user_model.dart';
import 'package:posto360/modules/core/domain/rest_client/api_routes/api_routes.dart';
import 'package:posto360/modules/core/domain/rest_client/posto_rest_client.dart';
import 'package:posto360/modules/equipe/domain/models/campanhas_resumo_model.dart';
import 'package:posto360/modules/equipe/domain/models/checklists_resumo_model.dart';
import 'package:posto360/modules/equipe/domain/models/cursos_resumo_model.dart';
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
      if (result.statusCode != null && result.statusCode! >= 400) {
        log(
          'Erro get colaborador [${result.statusCode}]',
          error: result.bodyString,
          stackTrace: StackTrace.current,
        );
        return ResultActionDTO.failure(
          'Erro ao buscar dados do colaborador',
          UserModel.empty(),
        );
      }
      final body = result.body;
      if (body is! Map<String, dynamic> ||
          body['userData'] is! Map<String, dynamic>) {
        return ResultActionDTO.failure(
          'Resposta inesperada do servidor',
          UserModel.empty(),
        );
      }
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

  @override
  Future<ResultActionDTO<ChecklistsResumoModel>> getChecklistsResumo({
    required int funcionarioCodigo,
    required String dataInicial,
    required String dataFinal,
  }) async {
    try {
      final result = await _postoRestClient.post(
        ApiRoutes.dashboardChecklists(),
        {
          'funcionarioCodigo': funcionarioCodigo,
          'dataInicial': dataInicial,
          'dataFinal': dataFinal,
        },
      );
      if (result.statusCode != null && result.statusCode! >= 400) {
        log(
          'Erro get checklists resumo [${result.statusCode}]',
          error: result.bodyString,
          stackTrace: StackTrace.current,
        );
        return ResultActionDTO.failure(
          'Erro ao buscar checklists',
          ChecklistsResumoModel.empty(),
        );
      }
      final body = result.body;
      if (body is! Map<String, dynamic>) {
        return ResultActionDTO.failure(
          'Resposta inesperada do servidor',
          ChecklistsResumoModel.empty(),
        );
      }
      return ResultActionDTO.success(
        data: ChecklistsResumoModel.fromMap(body),
      );
    } catch (e, s) {
      log('Erro get checklists resumo', error: e, stackTrace: s);
      return ResultActionDTO.failure(
        'Erro ao buscar checklists',
        ChecklistsResumoModel.empty(),
      );
    }
  }

  @override
  Future<ResultActionDTO<CursosResumoModel>> getCursosResumo({
    required int funcionarioCodigo,
    required String dataInicial,
    required String dataFinal,
  }) async {
    try {
      final result = await _postoRestClient.post(ApiRoutes.dashboardCursos(), {
        'funcionarioCodigo': funcionarioCodigo,
        'dataInicial': dataInicial,
        'dataFinal': dataFinal,
      });
      if (result.statusCode != null && result.statusCode! >= 400) {
        log(
          'Erro get cursos resumo [${result.statusCode}]',
          error: result.bodyString,
          stackTrace: StackTrace.current,
        );
        return ResultActionDTO.failure(
          'Erro ao buscar cursos',
          CursosResumoModel.empty(),
        );
      }
      final body = result.body;
      if (body is! Map<String, dynamic>) {
        return ResultActionDTO.failure(
          'Resposta inesperada do servidor',
          CursosResumoModel.empty(),
        );
      }
      return ResultActionDTO.success(data: CursosResumoModel.fromMap(body));
    } catch (e, s) {
      log('Erro get cursos resumo', error: e, stackTrace: s);
      return ResultActionDTO.failure(
        'Erro ao buscar cursos',
        CursosResumoModel.empty(),
      );
    }
  }

  @override
  Future<ResultActionDTO<CampanhasResumoModel>> getCampanhasResumo({
    required int funcionarioCodigo,
    required List<int> idsCampanhas,
    required String dataInicial,
    required String dataFinal,
  }) async {
    try {
      final result = await _postoRestClient.post(ApiRoutes.dashboardCampanhas(), {
        'funcionarioCodigo': funcionarioCodigo,
        'idsCampanhas': idsCampanhas,
        'dataInicial': dataInicial,
        'dataFinal': dataFinal,
      });
      if (result.statusCode != null && result.statusCode! >= 400) {
        log(
          'Erro get campanhas resumo [${result.statusCode}]',
          error: result.bodyString,
          stackTrace: StackTrace.current,
        );
        return ResultActionDTO.failure(
          'Erro ao buscar campanhas',
          CampanhasResumoModel.empty(),
        );
      }
      final body = result.body;
      if (body is! Map<String, dynamic>) {
        return ResultActionDTO.failure(
          'Resposta inesperada do servidor',
          CampanhasResumoModel.empty(),
        );
      }
      return ResultActionDTO.success(
        data: CampanhasResumoModel.fromMap(body),
      );
    } catch (e, s) {
      log('Erro get campanhas resumo', error: e, stackTrace: s);
      return ResultActionDTO.failure(
        'Erro ao buscar campanhas',
        CampanhasResumoModel.empty(),
      );
    }
  }
}
