import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/motoristas/domain/models/dashboard_motorista_model.dart';
import 'package:posto360/modules/motoristas/domain/repositories/motoristas_repository.dart';
import 'package:posto360/modules/motoristas/infra/services/motoristas_service.dart';

class MotoristasServiceImpl extends MotoristasService {
  final MotoristasRepository _motoristasRepository;

  MotoristasServiceImpl({required MotoristasRepository motoristasRepository})
      : _motoristasRepository = motoristasRepository;

  @override
  Future<ResultActionDTO<DashboardMotoristaModel>> getDashboard({
    required String motoristaId,
    required DateTime data,
  }) async =>
      await _motoristasRepository.getDashboard(
        motoristaId: motoristaId,
        data: data,
      );
}
