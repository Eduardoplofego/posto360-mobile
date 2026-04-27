import 'package:posto360/modules/campanhas/campanhas_controller.dart';
import 'package:posto360/modules/campanhas/domain/models/performance_equipe_model.dart';
import 'package:posto360/modules/campanhas/infra/services/performance_service.dart';
import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';

class CampanhasGerenteController extends CampanhasController {
  final PerformanceService _performanceService;

  // Mantemos uma referencia local de `performanceService` (em vez de
  // `super.performanceService`) porque o pai privatiza o field e o override
  // de `fetchEquipePerformances` precisa chamar `getEquipePerformancesGerente`.
  // ignore: use_super_parameters
  CampanhasGerenteController({
    required super.campanhaService,
    required super.authService,
    required PerformanceService performanceService,
  }) : _performanceService = performanceService,
       super(performanceService: performanceService);

  @override
  Future<ResultActionDTO<List<PerformanceEquipeModel>>> fetchEquipePerformances({
    required int filialId,
    required List<int> campanhasId,
    required String data,
  }) {
    return _performanceService.getEquipePerformancesGerente(
      filialId: filialId,
      campanhasId: campanhasId,
      data: data,
    );
  }
}
