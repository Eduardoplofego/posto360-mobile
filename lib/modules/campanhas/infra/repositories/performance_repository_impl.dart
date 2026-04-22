import 'dart:developer';

import 'package:posto360/modules/campanhas/domain/models/performance_individual_model.dart';
import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/core/domain/rest_client/api_routes/api_routes.dart';
import 'package:posto360/modules/core/domain/rest_client/posto_rest_client.dart';
import 'package:posto360/modules/campanhas/domain/models/performance_equipe_model.dart';

import '../../domain/repositories/performance_repository.dart';

class PerformanceRepositoryImpl extends PerformanceRepository {
  final PostoRestClient _restClient;

  PerformanceRepositoryImpl({required PostoRestClient restClient})
    : _restClient = restClient;

  @override
  Future<ResultActionDTO<PerformanceIndividualModel>> getPerformanceIndividual({
    required int codigoFuncionario,
    required int campanhaId,
    required String data,
  }) async {
    try {
      final response = await _restClient.post(
        ApiRoutes.performanceIndividual(),
        {
          "campanhaId": campanhaId,
          "funcionarioCodigo": codigoFuncionario,
          "data": data,
        },
      );

      if (response.body == null || (response.statusCode != 200)) {
        return ResultActionDTO.failure(
          'Não foi possível obter sua performance nas campanhas\nRecarregue a página novamente',
          null,
        );
      }

      final performance = PerformanceIndividualModel.fromJson(response.body);

      return ResultActionDTO.success(data: performance);
    } catch (e, s) {
      log('Erro get performances', error: e, stackTrace: s);
      return ResultActionDTO.failure('Erro ao buscar performance', null);
    }
  }

  @override
  Future<ResultActionDTO<PerformanceEquipeModel>> getPerformanceEquipe({
    required int filialId,
    required int campanhaId,
    required String data,
  }) async {
    try {
      final response = await _restClient.post(ApiRoutes.performanceEquipe(), {
        "data": data,
        "filialId": filialId,
        "campanhaId": campanhaId,
      });

      if (response.body == null || (response.statusCode != 200)) {
        return ResultActionDTO.failure(
          'Não foi possível obter sua performance nas campanhas\nRecarregue a página novamente',
          null,
        );
      }

      final performance = PerformanceEquipeModel.fromJson(response.body);

      return ResultActionDTO.success(data: performance);
    } catch (e, s) {
      log('Erro get performances', error: e, stackTrace: s);
      return ResultActionDTO.failure('Erro ao buscar performance', null);
    }
  }
}
