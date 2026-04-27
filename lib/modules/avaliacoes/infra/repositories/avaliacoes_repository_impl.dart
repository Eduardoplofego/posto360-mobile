import 'dart:developer';
import 'package:posto360/modules/avaliacoes/domain/dto/confirm_discretions_dto.dart';
import 'package:posto360/modules/avaliacoes/domain/models/avaliacao_details_model.dart';
import 'package:posto360/modules/avaliacoes/domain/models/avaliacoes_avaliador_model.dart';
import 'package:posto360/modules/avaliacoes/domain/models/avaliacoes_model.dart';
import 'package:posto360/modules/avaliacoes/domain/models/avaliator_dicretions_model.dart';
import 'package:posto360/modules/avaliacoes/domain/models/user_model.dart';
import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/core/domain/rest_client/api_routes/api_routes.dart';
import 'package:posto360/modules/core/domain/rest_client/posto_rest_client.dart';
import '../../domain/repositories/avaliacoes_module_repository.dart';

class AvaliacoesModuleRepositoryImpl implements AvaliacoesModuleRepository {
  final PostoRestClient _restClient;

  AvaliacoesModuleRepositoryImpl(this._restClient);

  @override
  Future<ResultActionDTO<List<AvaliacoesModel>>> getAvaliacoesAvaliado({
    required String dataInicial,
    required String dataFinal,
    required String usuarioId,
  }) async {
    try {
      final result = await _restClient.post(
        ApiRoutes.avaliacoesAvaliadoFeitas(),
        {
          "dataInicial": dataInicial,
          "dataFinal": dataFinal,
          "usuarioId": usuarioId,
        },
      );

      if (result.statusCode != null && result.statusCode! >= 400) {
        log(
          'Erro get avaliacoes data',
          error: result.bodyString,
          stackTrace: StackTrace.current,
        );
        return ResultActionDTO.failure('Erro ao buscar dados', null);
      }

      final avaliacoes =
          result.body
              .map<AvaliacoesModel>((model) => AvaliacoesModel.fromJson(model))
              .toList() ??
          [];

      return ResultActionDTO.success(data: avaliacoes);
    } catch (e, s) {
      log('Erro get avaliacoes', error: e, stackTrace: s);
      return ResultActionDTO.failure('Erro ao carregar avaliacoes', null);
    }
  }

  @override
  Future<ResultActionDTO<List<AvaliacaoDetailsModel>>> getCriterios({
    required int gestaoAvaliacaoId,
    required int modeloAvaliacaoId,
  }) async {
    try {
      final result = await _restClient.post(ApiRoutes.avaliacoesCriterios(), {
        'gestaoAvaliacaoId': gestaoAvaliacaoId,
        'modeloAvaliacaoId': modeloAvaliacaoId,
      });

      if (result.statusCode != null && result.statusCode! >= 400) {
        log(
          'Erro get avaliacoes detalhes data',
          error: result.bodyString,
          stackTrace: StackTrace.current,
        );
        return ResultActionDTO.failure('Erro ao buscar dados', null);
      }

      final avaliacoes =
          result.body
              .map<AvaliacaoDetailsModel>(
                (model) => AvaliacaoDetailsModel.fromMap(model),
              )
              .toList() ??
          [];

      return ResultActionDTO.success(data: avaliacoes);
    } catch (e, s) {
      log('Erro get critérios', error: e, stackTrace: s);
      return ResultActionDTO.failure('Erro ao carregar critérios', null);
    }
  }

  @override
  Future<ResultActionDTO<List<AvaliacaoFinalizada>>> getAvaliadorFinalizadas({
    required String dataInicial,
    required String dataFinal,
    required String usuarioId,
  }) async {
    try {
      final result = await _restClient.post(
        ApiRoutes.avaliacoesAvaliadorFinalizadas(),
        {
          "dataInicial": dataInicial,
          "dataFinal": dataFinal,
          "usuarioId": usuarioId,
        },
      );

      if (result.statusCode != null && result.statusCode! >= 400) {
        log(
          'Erro get avaliacoes data',
          error: result.bodyString,
          stackTrace: StackTrace.current,
        );
        return ResultActionDTO.failure('Erro ao buscar dados', null);
      }

      final avaliacoes =
          result.body
                  .map<AvaliacaoFinalizada>(
                    (model) => AvaliacaoFinalizada.fromMap(model),
                  )
                  .toList()
              as List<AvaliacaoFinalizada>;

      return ResultActionDTO.success(data: avaliacoes);
    } catch (e, s) {
      log('Erro get avaliações finalizadas', error: e, stackTrace: s);
      return ResultActionDTO.failure(
        'Erro ao carregar avaliações finalizadas',
        null,
      );
    }
  }

  @override
  Future<ResultActionDTO<List<AvaliacaoPendente>>> getAvaliadorPendentes({
    required String dataAtual,
    required String usuarioId,
  }) async {
    try {
      final result = await _restClient.post(
        ApiRoutes.avaliacoesAvaliadorPendentes(),
        {"dataAtual": dataAtual, "usuarioId": usuarioId},
      );

      if (result.statusCode != null && result.statusCode! >= 400) {
        log(
          'Erro get avaliacoes data',
          error: result.bodyString,
          stackTrace: StackTrace.current,
        );
        return ResultActionDTO.failure('Erro ao buscar dados', null);
      }

      final avaliacoes =
          result.body
                  .map<AvaliacaoPendente>(
                    (model) => AvaliacaoPendente.fromMap(model),
                  )
                  .toList()
              as List<AvaliacaoPendente>;

      return ResultActionDTO.success(data: avaliacoes);
    } catch (e, s) {
      log('Erro get avaliações pendentes', error: e, stackTrace: s);
      return ResultActionDTO.failure(
        'Erro ao carregar avaliações pendentes',
        null,
      );
    }
  }

  @override
  Future<ResultActionDTO<List<UserAvaliationModel>>> getUsers({
    required int avaliacaoId,
  }) async {
    try {
      final result = await _restClient.post(
        ApiRoutes.avaliacoesAvaliadorUsuarios(),
        {"avaliacaoId": avaliacaoId},
      );

      if (result.statusCode != null && result.statusCode! >= 400) {
        log(
          'Erro get avaliacoes data',
          error: result.bodyString,
          stackTrace: StackTrace.current,
        );
        return ResultActionDTO.failure('Erro ao buscar dados', null);
      }
      // await Future.delayed(const Duration(seconds: 1));
      final users =
          result.body
              .map<UserAvaliationModel>(
                (model) => UserAvaliationModel.fromMap(model),
              )
              .toList() ??
          [];

      return ResultActionDTO.success(data: users);
    } catch (e, s) {
      log('Erro get usuários', error: e, stackTrace: s);
      return ResultActionDTO.failure('Erro ao carregar usuários', null);
    }
  }

  @override
  Future<ResultActionDTO<String>> setUser({
    required int avaliacaoId,
    required String usuarioId,
  }) async {
    try {
      final result = await _restClient.post(
        ApiRoutes.avaliacoesDefinirUsuario(),
        {"avaliacaoId": avaliacaoId, "usuarioId": usuarioId},
      );

      if (result.statusCode != null && result.statusCode! >= 400) {
        log(
          'Erro set user',
          error: result.bodyString,
          stackTrace: StackTrace.current,
        );
        return ResultActionDTO.failure('Erro ao definir usuário', null);
      }
      // await Future.delayed(const Duration(seconds: 1));
      final users =
          result.body
              .map<UserAvaliationModel>(
                (model) => UserAvaliationModel.fromMap(model),
              )
              .toList() ??
          [];

      return ResultActionDTO.success(data: users);
    } catch (e, s) {
      log('Erro set usuário', error: e, stackTrace: s);
      return ResultActionDTO.failure('Erro ao definir usuário', null);
    }
  }

  @override
  Future<ResultActionDTO<String>> startAvaliation({
    required int avaliacaoId,
  }) async {
    try {
      final result = await _restClient.post(ApiRoutes.avaliacoesIniciar(), {
        "avaliacaoId": avaliacaoId,
      });

      if (result.statusCode != null && result.statusCode! >= 400) {
        log(
          'Erro start avaliation',
          error: result.bodyString,
          stackTrace: StackTrace.current,
        );
        return ResultActionDTO.failure('Erro ao iniciar avaliação', null);
      }

      return ResultActionDTO.success(data: 'Iniciando avaliação com sucesso');
    } catch (e, s) {
      log('Erro start avaliation', error: e, stackTrace: s);
      return ResultActionDTO.failure('Erro ao iniciar avaliação', null);
    }
  }

  @override
  Future<ResultActionDTO<List<AvaliatorDicretionsModel>>>
  getAvaliadorCriterios({
    required int gestaoAvaliacaoId,
    required int modeloAvaliacaoId,
  }) async {
    try {
      final result = await _restClient.post(
        ApiRoutes.avaliacoesAvaliadorCriterios(),
        {"gestaoAvaliacaoId": 30, "modeloAvaliacaoId": 17},
      );

      if (result.statusCode != null && result.statusCode! >= 400) {
        log(
          'Erro get discretions',
          error: result.bodyString,
          stackTrace: StackTrace.current,
        );
        return ResultActionDTO.failure('Erro ao buscar critérios', null);
      }

      final discretions =
          result.body
              .map<AvaliatorDicretionsModel>(
                (model) => AvaliatorDicretionsModel.fromMap(model),
              )
              .toList() ??
          [];

      return ResultActionDTO.success(data: discretions);
    } catch (e, s) {
      log('Erro get discretions', error: e, stackTrace: s);
      return ResultActionDTO.failure('Erro ao buscar critérios', null);
    }
  }

  @override
  Future<ResultActionDTO<String>> confirmDiscretion({
    required ConfirmDiscretionsDto dto,
  }) async {
    try {
      final result = await _restClient
          .post(ApiRoutes.avaliacoesConfirmarCriterio(), {
            "criterioId": dto.id,
            "cumprido": dto.isFulfilled,
            "comentarios": dto.comment.isNotEmpty ? dto.comment : null,
          });

      if (result.statusCode != null && result.statusCode! >= 400) {
        log(
          'Erro confirm discretion',
          error: result.bodyString,
          stackTrace: StackTrace.current,
        );
        return ResultActionDTO.failure('Erro ao concluir critério', null);
      }

      return ResultActionDTO.success(data: 'Critério confirmado com sucesso');
    } catch (e, s) {
      log('Erro confirm discretion', error: e, stackTrace: s);
      return ResultActionDTO.failure('Erro ao concluir critério', null);
    }
  }

  @override
  Future<ResultActionDTO<List<UserAvaliationModel>>> concludeAvaliation({
    required int avaliacaoId,
  }) async {
    try {
      final result = await _restClient.post(
        ApiRoutes.avaliacoesConcluirAvaliation(),
        {"avaliacaoId": avaliacaoId},
      );

      if (result.statusCode != null && result.statusCode! >= 400) {
        log(
          'Erro conclude avaliation',
          error: result.bodyString,
          stackTrace: StackTrace.current,
        );
        return ResultActionDTO.failure('Erro ao finalizar avaliação', null);
      }

      return ResultActionDTO.success();
    } catch (e, s) {
      log('Erro conclude avaliation', error: e, stackTrace: s);
      return ResultActionDTO.failure('Erro ao finalizar avaliação', null);
    }
  }
}
