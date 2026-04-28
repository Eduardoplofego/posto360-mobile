import 'dart:developer';

import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/core/domain/rest_client/api_routes/api_routes.dart';
import 'package:posto360/modules/core/domain/rest_client/posto_rest_client.dart';
import 'package:posto360/modules/dash/domain/models/avaliacao_model.dart';

import '../../domain/repositories/avaliacoes_repository.dart';

class AvaliacoesRepositoryImpl implements AvaliacoesRepository {
  final PostoRestClient _restClient;

  AvaliacoesRepositoryImpl(this._restClient);

  @override
  Future<ResultActionDTO<AvaliacaoModel>> getAvaliacoes({
    required String funcionarioId,
    required String dataInicial,
    required String dataFinal,
  }) async {
    try {
      final result = await _restClient.post(ApiRoutes.dashboardAvaliacoes(), {
        "usuarioId": funcionarioId,
        "dataInicial": dataInicial,
        "dataFinal": dataFinal,
      });

      if (result.statusCode != null && result.statusCode! >= 400) {
        log(
          'Erro get dashboardData',
          error: result.bodyString,
          stackTrace: StackTrace.current,
        );
        return ResultActionDTO.failure('Erro ao buscar dados', null);
      }

      final avaliacoesMap = result.body as Map<String, dynamic>;

      return ResultActionDTO.success(
        data: AvaliacaoModel(
          total: avaliacoesMap['avaliacoes']['total'],
          feitas: avaliacoesMap['avaliacoes']['feitas'],
          penalidade:
              (avaliacoesMap['avaliacoes']['penalidade'] as num).toDouble(),
        ),
      );
    } catch (e, s) {
      log('Erro get campanhas', error: e, stackTrace: s);
      return ResultActionDTO.failure('Erro ao carregar campanhas', null);
    }
  }
}
