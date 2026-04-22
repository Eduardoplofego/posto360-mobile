import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/campanhas/domain/models/campanha_model.dart';

abstract class AppCampanhasRepository {
  Future<ResultActionDTO<List<CampanhaModel>>> getAllCampanhas({
    required int filialId,
    required String usuarioId,
    required int empresaId,
    required String dataInicial,
    required String dataFinal,
  });
}
