import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/dash/domain/models/campanha_model.dart';

abstract class CampanhasRepository {
  Future<ResultActionDTO<CampanhaModel>> getCampanha({required int campanhaId});
}
