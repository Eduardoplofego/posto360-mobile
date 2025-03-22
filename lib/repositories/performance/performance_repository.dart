import 'package:posto360/core/dto/result_action_dto.dart';
import 'package:posto360/models/performance_model.dart';

abstract class PerformanceRepository {
  Future<ResultActionDTO<List<PerformanceModel>>> getPerformances({
    required String codigoFuncionario,
    required List<int> campanhasId,
  });
}
