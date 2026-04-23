import 'dart:developer';
import 'package:posto360/modules/avaliacoes/domain/mocks/avaliacoes_mocks.dart';
import 'package:posto360/modules/avaliacoes/domain/models/avaliacao_details_model.dart';
import 'package:posto360/modules/avaliacoes/domain/models/avaliacoes_avaliador_model.dart';
import 'package:posto360/modules/avaliacoes/domain/models/avaliacoes_model.dart';
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
  Future<ResultActionDTO<List<AvaliacaoAvaliador>>> getAvaliadorFinalizadas({
    required String dataInicial,
    required String dataFinal,
    required String usuarioId,
  }) async {
    try {
      // final result = await _restClient.post(
      //   ApiRoutes.avaliacoesAvaliadorFinalizadas(),
      //   {
      //     "dataInicial": dataInicial,
      //     "dataFinal": dataFinal,
      //     "usuarioId": usuarioId,
      //   },
      // );

      // if (result.statusCode != null && result.statusCode! >= 400) {
      //   log(
      //     'Erro get avaliacoes data',
      //     error: result.bodyString,
      //     stackTrace: StackTrace.current,
      //   );
      //   return ResultActionDTO.failure('Erro ao buscar dados', null);
      // }

      // final avaliacoes =
      //     result.body
      //         .map<AvaliacaoFinalizada>(
      //           (model) => AvaliacaoFinalizada.fromMap(model),
      //         )
      //         .toList() ??
      //     [];

      return ResultActionDTO.success(data: []);
    } catch (e, s) {
      log('Erro get avaliações finalizadas', error: e, stackTrace: s);
      return ResultActionDTO.failure(
        'Erro ao carregar avaliações finalizadas',
        null,
      );
    }
  }

  @override
  Future<ResultActionDTO<List<AvaliacaoAvaliador>>> getAvaliadorPendentes({
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
              .toList() ??
          [];

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
}
