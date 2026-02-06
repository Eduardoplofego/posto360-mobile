import 'dart:developer';

import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/core/domain/rest_client/api_routes/api_routes.dart';
import 'package:posto360/modules/core/domain/rest_client/posto_rest_client.dart';

import 'package:posto360/modules/dash/domain/models/dashboard_model.dart';

import '../../domain/repositories/dashboard_repository.dart';

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
      final resultCampanhas = await _restClient
          .post(ApiRoutes.dashboardCampanhas(), {
            "funcionarioCodigo": funcionarioCodigo,
            "data": data,
            "idsCampanhas": idsCamapnhas,
          });
      if (resultCampanhas.statusCode != null &&
          resultCampanhas.statusCode! >= 400) {
        log(
          'Erro get dashboardData',
          error: resultCampanhas.bodyString,
          stackTrace: StackTrace.current,
        );
        return ResultActionDTO.failure(
          'Erro ao buscar dados',
          DashboardModel.empty(),
        );
      }
      final resultCursos = await _restClient.post(ApiRoutes.dashboardCursos(), {
        "funcionarioCodigo": funcionarioCodigo,
        "data": data,
      });
      if (resultCursos.statusCode != null && resultCursos.statusCode! >= 400) {
        log(
          'Erro get dashboardData',
          error: resultCursos.bodyString,
          stackTrace: StackTrace.current,
        );
        return ResultActionDTO.failure(
          'Erro ao buscar dados',
          DashboardModel.empty(),
        );
      }

      final resultChecklists = await _restClient.post(
        ApiRoutes.dashboardChecklists(),
        {"funcionarioCodigo": funcionarioCodigo, "data": data},
      );
      if (resultChecklists.statusCode != null &&
          resultChecklists.statusCode! >= 400) {
        log(
          'Erro get dashboardData',
          error: resultChecklists.bodyString,
          stackTrace: StackTrace.current,
        );
        return ResultActionDTO.failure(
          'Erro ao buscar dados',
          DashboardModel.empty(),
        );
      }

      final campanhasMap = resultCampanhas.body as Map<String, dynamic>;
      final cursosMap = resultCursos.body as Map<String, dynamic>;
      final checklistsMap = resultChecklists.body as Map<String, dynamic>;
      final dashboardModel = DashboardModel.fromMap({
        ...campanhasMap,
        ...cursosMap,
        ...checklistsMap,
      });
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
