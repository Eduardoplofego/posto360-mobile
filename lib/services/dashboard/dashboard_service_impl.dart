import 'package:posto360/core/dto/result_action_dto.dart';

import 'package:posto360/models/dashboard_model.dart';
import 'package:posto360/repositories/dashboard/dashboard_repository.dart';

import './dashboard_service.dart';

class DashboardServiceImpl extends DashboardService {
  final DashboardRepository _dashboardRepository;

  DashboardServiceImpl({required DashboardRepository dashboardRepository})
    : _dashboardRepository = dashboardRepository;

  @override
  Future<ResultActionDTO<DashboardModel>> getDashboardData({
    required int funcionarioCodigo,
    required List<int> idsCamapnhas,
    required String data,
  }) async => await _dashboardRepository.getDashboardData(
    funcionarioCodigo: funcionarioCodigo,
    idsCamapnhas: idsCamapnhas,
    data: data,
  );
}
