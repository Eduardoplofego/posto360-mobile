import 'dart:developer';

import 'package:posto360/core/dto/result_action_dto.dart';
import 'package:posto360/core/rest_client/api_routes/api_routes.dart';
import 'package:posto360/core/rest_client/posto_rest_client.dart';

import 'package:posto360/models/dashboard_model.dart';

import './dashboard_repository.dart';

class DashboardRepositoryImpl extends DashboardRepository {
  final PostoRestClient _restClient;

  DashboardRepositoryImpl({required PostoRestClient restClient})
    : _restClient = restClient;

  @override
  Future<ResultActionDTO<DashboardModel>> getDashboardData({
    required int funcionarioCodigo,
    required List<int> idsCamapnhas,
    required String data,
  }) async {
    try {
      final result = await _restClient.post(ApiRoutes.dashboard(), {
        "funcionarioCodigo": funcionarioCodigo,
        "idsCampanhas": idsCamapnhas,
        "data": data,
      });
      if (result.statusCode != null && result.statusCode! >= 400) {
        return ResultActionDTO.failure(
          'Erro ao buscar dados',
          DashboardModel.empty(),
        );
      }
      final resultMap = result.body as Map<String, dynamic>;
      final dashboardModel = DashboardModel.fromMap(resultMap);
      return ResultActionDTO.success(data: dashboardModel);
    } catch (e, s) {
      log('Erro get dashboardData', error: e, stackTrace: s);
      return ResultActionDTO.failure(
        'Erro ao buscar dados',
        DashboardModel.empty(),
      );
    }
  }
}
