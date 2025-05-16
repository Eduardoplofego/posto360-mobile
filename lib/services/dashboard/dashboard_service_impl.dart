import 'package:posto360/core/dto/result_action_dto.dart';
import 'package:posto360/models/campanha_model.dart';

import 'package:posto360/models/dashboard_model.dart';
import 'package:posto360/repositories/dashboard/dashboard_repository.dart';
import 'package:posto360/services/performance/performance_service.dart';

import './dashboard_service.dart';

class DashboardServiceImpl extends DashboardService {
  final DashboardRepository _dashboardRepository;
  final PerformanceService _performanceService;

  DashboardServiceImpl({
    required DashboardRepository dashboardRepository,
    required PerformanceService performanceService,
  }) : _dashboardRepository = dashboardRepository,
       _performanceService = performanceService;

  @override
  Future<ResultActionDTO<DashboardModel>> getDashboardData({
    required int funcionarioCodigo,
    required List<CampanhaModel> campanhas,
    required String data,
  }) async {
    var idsCamapnhas = _getCampanhasIds(campanhas: campanhas);

    final dashResult = await _dashboardRepository.getDashboardData(
      funcionarioCodigo: funcionarioCodigo,
      idsCamapnhas: idsCamapnhas,
      data: data,
    );

    if (dashResult.success) {
      // pegar performances das campanhas e settar no dashboardModel
      DashboardModel dashModel = dashResult.data!;

      final performances = await _performanceService.getPerformances(
        codigoFuncionario: funcionarioCodigo,
        campanhasId: idsCamapnhas,
        dataMes: data,
      );

      var totalAtingido = 0;
      if (performances.success) {
        for (var performance in performances.data!) {
          final campanha = campanhas.firstWhere(
            (camp) => camp.campanhaId == performance.campanhaId,
          );
          if (performance.unidadesVendidas > campanha.volumeBonificacao) {
            totalAtingido++;
          }
        }
        dashModel.quantidadeCampanhas = performances.data!.length;
        dashModel.realizadoCampanhas = totalAtingido;
      }

      return ResultActionDTO.success(data: dashModel);
    } else {
      return ResultActionDTO.failure(
        'Erro ao buscar performances',
        DashboardModel.empty(),
      );
    }
  }

  List<int> _getCampanhasIds({required List<CampanhaModel> campanhas}) {
    var idsCamps = <int>[];
    for (var campanha in campanhas) {
      idsCamps.add(campanha.campanhaId);
    }
    return idsCamps;
  }
}
