import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/dash/domain/models/dashboard_model.dart';

abstract class DashboardRepository {
  Future<ResultActionDTO<DashboardModel>> getDashboardData({
    required int funcionarioCodigo,
    required List<int> idsCamapnhas,
    required String dataInicial,
    required String dataFinal,
  });
}
