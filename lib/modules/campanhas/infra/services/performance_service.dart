import 'package:posto360/modules/campanhas/domain/models/performance_equipe_model.dart';
import 'package:posto360/modules/campanhas/domain/models/performance_individual_model.dart';
import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';

abstract class PerformanceService {
  Future<ResultActionDTO<List<PerformanceIndividualModel>>>
  getIndividualPerformances({
    required int codigoFuncionario,
    required List<int> campanhasId,
    required String dataMes,
  });
  Future<ResultActionDTO<List<PerformanceEquipeModel>>> getEquipePerformances({
    required int filialId,
    required List<int> campanhasId,
    required String data,
  });
}
