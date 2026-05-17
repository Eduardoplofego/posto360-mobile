import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/motoristas/domain/models/dashboard_motorista_model.dart';

abstract class MotoristasService {
  Future<ResultActionDTO<DashboardMotoristaModel>> getDashboard({
    required String motoristaId,
    required DateTime data,
  });
}
