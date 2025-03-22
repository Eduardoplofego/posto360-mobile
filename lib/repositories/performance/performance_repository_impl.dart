import 'dart:developer';

import 'package:posto360/core/dto/result_action_dto.dart';
import 'package:posto360/core/rest_client/api_routes/api_routes.dart';
import 'package:posto360/core/rest_client/posto_rest_client.dart';
import 'package:posto360/models/performance_model.dart';

import './performance_repository.dart';

class PerformanceRepositoryImpl extends PerformanceRepository {
  final PostoRestClient _restClient;

  PerformanceRepositoryImpl({required PostoRestClient restClient})
    : _restClient = restClient;

  @override
  Future<ResultActionDTO<List<PerformanceModel>>> getPerformances({
    required String codigoFuncionario,
    required List<int> campanhasId,
  }) async {
    try {
      final response = await _restClient.post(ApiRoutes.performance(), {
        "funcionarioCodigo": codigoFuncionario,
        "campanhas": campanhasId,
      });

      final performancesMap = response.body['performances'];
      final performancesList =
          performancesMap
              .map<PerformanceModel>(
                (performance) => PerformanceModel.fromMap(performance),
              )
              .toList();

      return ResultActionDTO.success(data: performancesList);
    } catch (e, s) {
      log('Erro get performances', error: e, stackTrace: s);
      return ResultActionDTO.failure('Erro ao buscar performance', []);
    }
  }
}
