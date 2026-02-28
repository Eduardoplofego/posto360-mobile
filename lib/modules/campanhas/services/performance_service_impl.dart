import 'package:posto360/modules/campanhas/domain/models/performance_individual_model.dart';
import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/campanhas/domain/models/performance_equipe_model.dart';
import 'package:posto360/modules/campanhas/domain/repositories/performance_repository.dart';

import '../infra/services/performance_service.dart';

class PerformanceServiceImpl extends PerformanceService {
  final PerformanceRepository _performanceRepository;

  PerformanceServiceImpl({required PerformanceRepository performanceRepository})
    : _performanceRepository = performanceRepository;

  @override
  Future<ResultActionDTO<List<PerformanceIndividualModel>>>
  getIndividualPerformances({
    required int codigoFuncionario,
    required List<int> campanhasId,
    required String dataMes,
  }) async {
    final listPerformances = <PerformanceIndividualModel>[];

    for (var campanhaId in campanhasId) {
      final result = await _performanceRepository.getPerformanceIndividual(
        codigoFuncionario: codigoFuncionario,
        campanhaId: campanhaId,
        data: dataMes,
      );
      if (result.isError) {
        return ResultActionDTO.failure(
          'Erro ao calcular performance individual',
          [],
        );
      }

      listPerformances.add(result.data!);
    }

    return ResultActionDTO.success(data: listPerformances);
  }

  @override
  Future<ResultActionDTO<List<PerformanceEquipeModel>>> getEquipePerformances({
    required int filialId,
    required List<int> campanhasId,
    required String data,
  }) async {
    final listPerformances = <PerformanceEquipeModel>[];

    for (var campanhaId in campanhasId) {
      final result = await _performanceRepository.getPerformanceEquipe(
        filialId: filialId,
        campanhaId: campanhaId,
        data: data,
      );
      if (result.isError) {
        return ResultActionDTO.failure(
          'Erro ao calcular performance de equipe',
          [],
        );
      }

      listPerformances.add(result.data!);
    }

    return ResultActionDTO.success(data: listPerformances);
  }
}
