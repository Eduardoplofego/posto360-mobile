import 'dart:developer';
import 'package:posto360/modules/avaliacoes/domain/models/avaliacao_details_model.dart';
import 'package:posto360/modules/avaliacoes/domain/models/avaliacoes_model.dart';
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
      log('Erro get campanhas', error: e, stackTrace: s);
      return ResultActionDTO.failure('Erro ao carregar campanhas', null);
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
      log('Erro get campanhas', error: e, stackTrace: s);
      return ResultActionDTO.failure('Erro ao carregar campanhas', null);
    }
  }
}
