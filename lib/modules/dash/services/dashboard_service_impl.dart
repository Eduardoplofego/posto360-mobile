import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/campanhas/domain/models/campanha_model.dart';

import 'package:posto360/modules/dash/domain/models/dashboard_model.dart';
import 'package:posto360/modules/dash/domain/repositories/dashboard_repository.dart';
import 'package:posto360/modules/campanhas/infra/services/performance_service.dart';

import '../infra/services/dashboard_service.dart';

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
    required List<int> campanhasIds,
    required String data,
  }) async {
    // var idsCamapnhas = _getCampanhasIds(campanhas: campanhas);

    final dashResult = await _dashboardRepository.getDashboardData(
      funcionarioCodigo: funcionarioCodigo,
      idsCamapnhas: campanhasIds,
      data: data,
    );

    return dashResult;

    // if (dashResult.success) {
    //   // pegar performances das campanhas e settar no dashboardModel
    //   DashboardModel dashModel = dashResult.data!;

    //   final performances = await _performanceService.getPerformances(
    //     codigoFuncionario: funcionarioCodigo,
    //     campanhasId: campanhasIds,
    //     dataMes: data,
    //   );

    //   var totalAtingido = 0;
    //   // if (performances.success) {
    //   //   for (var performance in performances.data!) {
    //   //     final campanha = campanhas.firstWhere(
    //   //       (camp) => camp.campanhaId == performance.campanhaId,
    //   //     );
    //   //     if (performance.unidadesVendidas > campanha.volumeBonificacao) {
    //   //       totalAtingido++;
    //   //     }
    //   //   }
    //   //   dashModel.quantidadeCampanhas = performances.data!.length;
    //   //   dashModel.realizadoCampanhas = totalAtingido;
    //   // }

    //   return ResultActionDTO.success(data: dashModel);
    // } else {
    //   return ResultActionDTO.failure(
    //     'Erro ao buscar performances',
    //     DashboardModel.empty(),
    //   );
    // }
  }

  List<int> _getCampanhasIds({required List<CampanhaModel> campanhas}) {
    var idsCamps = <int>[];
    for (var campanha in campanhas) {
      idsCamps.add(campanha.campanhaId);
    }
    return idsCamps;
  }
}
