import 'package:posto360/core/dto/result_action_dto.dart';
import 'package:posto360/models/performance_model.dart';
import 'package:posto360/repositories/performance/performance_repository.dart';

import './performance_service.dart';

class PerformanceServiceImpl extends PerformanceService {
  final PerformanceRepository _performanceRepository;

  PerformanceServiceImpl({required PerformanceRepository performanceRepository})
    : _performanceRepository = performanceRepository;

  @override
  Future<ResultActionDTO<List<PerformanceModel>>> getPerformances({
    required int codigoFuncionario,
    required List<int> campanhasId,
    required String dataMes,
  }) async {
    // final dataMesFormatada = DataFormatters.formatarData(dataMes);
    final result = await _performanceRepository.getPerformances(
      codigoFuncionario: codigoFuncionario,
      campanhasId: campanhasId,
      data: dataMes,
    );
    if (result.isError) {
      return ResultActionDTO.failure('Erro ao calcular performance', []);
    }

    final performancesList = result.data!;

    return ResultActionDTO.success(data: performancesList);
  }
}
