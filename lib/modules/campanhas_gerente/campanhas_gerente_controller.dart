import 'package:posto360/modules/campanhas/campanhas_controller.dart';
import 'package:posto360/modules/campanhas/domain/models/campanha_model.dart';
import 'package:posto360/modules/campanhas/domain/models/performance_equipe_model.dart';
import 'package:posto360/modules/campanhas/infra/services/app_campanhas_service.dart';
import 'package:posto360/modules/campanhas/infra/services/performance_service.dart';
import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/core/domain/services/auth_service.dart';

class CampanhasGerenteController extends CampanhasController {
  final AppCampanhasService _campanhasService;
  final PerformanceService _performanceService;

  // Mantemos referencias locais (em vez de `super.xxx`) porque o pai privatiza
  // os fields e os overrides precisam chamar as variantes de gerente.
  // ignore: use_super_parameters
  CampanhasGerenteController({
    required AppCampanhasService campanhaService,
    required AuthService authService,
    required PerformanceService performanceService,
  }) : _campanhasService = campanhaService,
       _performanceService = performanceService,
       super(
         campanhaService: campanhaService,
         authService: authService,
         performanceService: performanceService,
       );

  @override
  double get valueTotalBonus {
    double total = 0.0;
    for (var campanha in campanhas) {
      total += campanha.bonificacaoIndividualConquistada;
      total += campanha.bonificacaoGerenteConquistada;
    }
    return total;
  }

  @override
  Future<ResultActionDTO<List<CampanhaModel>>> fetchCampanhas({
    required int filialId,
    required String usuarioId,
    required int empresaId,
    required DateTime data,
  }) {
    return _campanhasService.getAllCampanhasGerente(
      filialId: filialId,
      usuarioId: usuarioId,
      empresaId: empresaId,
      data: data,
    );
  }

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
