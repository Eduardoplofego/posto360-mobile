import 'package:posto360/core/dto/result_action_dto.dart';
import 'package:posto360/core/utils/data_formatters.dart';
import 'package:posto360/models/performance_model.dart';
import 'package:posto360/repositories/performance/performance_repository.dart';

import './performance_service.dart';

class PerformanceServiceImpl extends PerformanceService {
  final PerformanceRepository _performanceRepository;

  PerformanceServiceImpl({required PerformanceRepository performanceRepository})
    : _performanceRepository = performanceRepository;

  @override
  Future<ResultActionDTO<List<PerformanceModel>>> getPerformances({
    required String codigoFuncionario,
    required List<int> campanhasId,
    required DateTime dataMes,
  }) async {
    final dataMesFormatada = DataFormatters.formatarData(dataMes);
    final result = await _performanceRepository.getPerformances(
      codigoFuncionario: codigoFuncionario,
      campanhasId: campanhasId,
      data: dataMesFormatada,
    );
    if (result.isError) {
      return ResultActionDTO.failure('Erro ao calcular performance', []);
    } else if (result.data!.containsKey('message')) {
      return ResultActionDTO.success(data: []);
    }

    final mapResult = result.data!;
    final performancesList =
        mapResult.entries
            .map<PerformanceModel>(
              (performance) => PerformanceModel.fromMap(performance.value),
            )
            .toList();
    return ResultActionDTO.success(data: performancesList);
  }
}
