import 'package:posto360/core/dto/result_action_dto.dart';
import 'package:posto360/models/dashboard_model.dart';

abstract class DashboardService {
  Future<ResultActionDTO<DashboardModel>> getDashboardData({
    required int funcionarioCodigo,
    required List<int> idsCamapnhas,
    required String data,
  });
}
