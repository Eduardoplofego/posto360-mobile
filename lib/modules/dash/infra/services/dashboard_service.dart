import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/campanhas/domain/models/campanha_model.dart';
import 'package:posto360/modules/dash/domain/models/dashboard_model.dart';

abstract class DashboardService {
  Future<ResultActionDTO<DashboardModel>> getDashboardData({
    required int funcionarioCodigo,
    required List<CampanhaModel> campanhas,
    required String data,
  });
}
