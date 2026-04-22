import 'package:posto360/modules/campanhas/domain/models/performance_equipe_model.dart';
import 'package:posto360/modules/campanhas/domain/models/performance_individual_model.dart';
import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';

abstract class PerformanceRepository {
  Future<ResultActionDTO<PerformanceIndividualModel>> getPerformanceIndividual({
    required int codigoFuncionario,
    required int campanhaId,
    required String data,
  });
  Future<ResultActionDTO<PerformanceEquipeModel>> getPerformanceEquipe({
    required int filialId,
    required int campanhaId,
    required String data,
  });
}
