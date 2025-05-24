import 'dart:developer';

import 'package:posto360/core/dto/result_action_dto.dart';
import 'package:posto360/core/rest_client/api_routes/api_routes.dart';
import 'package:posto360/core/rest_client/posto_rest_client.dart';

import './performance_repository.dart';

class PerformanceRepositoryImpl extends PerformanceRepository {
  final PostoRestClient _restClient;

  PerformanceRepositoryImpl({required PostoRestClient restClient})
    : _restClient = restClient;

  @override
  Future<ResultActionDTO<Map<String, dynamic>>> getPerformances({
    required String codigoFuncionario,
    required List<int> campanhasId,
    required String data,
  }) async {
    try {
      final response = await _restClient.post(ApiRoutes.performance(), {
        "funcionarioCodigo": codigoFuncionario,
        "idsCampanhas": campanhasId,
        "data": data,
      });

      if (response.body == null) {
        return ResultActionDTO.failure(
          'Não foi possível obter sua performance nas campanhas\nRecarregue a página novamente',
          {},
        );
      }
      if (response.body == null) {
        return ResultActionDTO.success(data: {});
      }
      final performancesMap = response.body;

      return ResultActionDTO.success(data: performancesMap);
    } catch (e, s) {
      log('Erro get performances', error: e, stackTrace: s);
      return ResultActionDTO.failure('Erro ao buscar performance', {});
    }
  }
}
