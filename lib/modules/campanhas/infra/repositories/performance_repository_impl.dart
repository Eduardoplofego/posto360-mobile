import 'dart:developer';

import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/core/domain/rest_client/api_routes/api_routes.dart';
import 'package:posto360/modules/core/domain/rest_client/posto_rest_client.dart';
import 'package:posto360/modules/campanhas/domain/models/performance_model.dart';

import '../../domain/repositories/performance_repository.dart';

class PerformanceRepositoryImpl extends PerformanceRepository {
  final PostoRestClient _restClient;

  PerformanceRepositoryImpl({required PostoRestClient restClient})
    : _restClient = restClient;

  @override
  Future<ResultActionDTO<List<PerformanceModel>>> getPerformances({
    required int codigoFuncionario,
    required List<int> campanhasId,
    required String data,
  }) async {
    try {
      final response = await _restClient.post(ApiRoutes.performance(), {
        "funcionarioCodigo": codigoFuncionario,
        "idsCampanhas": campanhasId,
        "data": data,
      });

      if (response.body == null ||
          (response.statusCode != 200 &&
              response.body['performances'] == null)) {
        return ResultActionDTO.failure(
          'Não foi possível obter sua performance nas campanhas\nRecarregue a página novamente',
          [],
        );
      }
      if (response.body == null || response.body['performances'] == null) {
        return ResultActionDTO.success(data: []);
      }
      final performancesMap = response.body['performances'];

      final performances =
          performancesMap
              .map<PerformanceModel>((perf) => PerformanceModel.fromMap(perf))
              .toList();

      return ResultActionDTO.success(data: performances);
    } catch (e, s) {
      log('Erro get performances', error: e, stackTrace: s);
      return ResultActionDTO.failure('Erro ao buscar performance', []);
    }
  }
}
