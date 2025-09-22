import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/campanhas/domain/models/performance_model.dart';

abstract class PerformanceRepository {
  Future<ResultActionDTO<List<PerformanceModel>>> getPerformances({
    required int codigoFuncionario,
    required List<int> campanhasId,
    required String data,
  });
}
