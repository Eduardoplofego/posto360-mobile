import 'package:posto360/core/dto/result_action_dto.dart';
import 'package:posto360/models/campanha_model.dart';

abstract class CampanhasService {
  Future<ResultActionDTO<List<CampanhaModel>>> getAllCampanhas({
    required int filialId,
    required String tipoUsuario,
  });
}
