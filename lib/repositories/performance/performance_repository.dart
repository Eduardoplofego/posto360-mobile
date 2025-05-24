import 'package:posto360/core/dto/result_action_dto.dart';

abstract class PerformanceRepository {
  Future<ResultActionDTO<Map<String, dynamic>>> getPerformances({
    required String codigoFuncionario,
    required List<int> campanhasId,
    required String data,
  });
}
