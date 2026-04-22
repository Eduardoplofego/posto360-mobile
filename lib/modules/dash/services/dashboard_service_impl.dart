import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/core/domain/helpers/date_helper.dart';
import 'package:posto360/modules/core/domain/utils/data_formatters.dart';
import 'package:posto360/modules/dash/domain/models/dashboard_model.dart';
import 'package:posto360/modules/dash/domain/repositories/dashboard_repository.dart';
import 'package:posto360/modules/campanhas/infra/services/performance_service.dart';

import '../infra/services/dashboard_service.dart';

class DashboardServiceImpl extends DashboardService {
  final DashboardRepository _dashboardRepository;

  DashboardServiceImpl({
    required DashboardRepository dashboardRepository,
    required PerformanceService performanceService,
  }) : _dashboardRepository = dashboardRepository;

  @override
  Future<ResultActionDTO<DashboardModel>> getDashboardData({
    required int funcionarioCodigo,
    required List<int> campanhasIds,
    required DateTime dataAtual,
  }) async {
    final (dataInicial, dataFinal) = DateHelper.getInitialAndLastCurrentDate(
      dataAtual,
    );
    final dashResult = await _dashboardRepository.getDashboardData(
      funcionarioCodigo: funcionarioCodigo,
      idsCamapnhas: campanhasIds,
      dataInicial: DataFormatters.formatarData(dataInicial),
      dataFinal: DataFormatters.formatarData(dataFinal),
    );

    return dashResult;
  }
}
