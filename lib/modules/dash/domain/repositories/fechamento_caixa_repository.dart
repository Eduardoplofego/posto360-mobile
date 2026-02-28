import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/dash/domain/models/cartoes_model.dart';

abstract class FechamentoCaixaRepository {
  Future<ResultActionDTO<CartoesModel>> getFechamento({
    required String usuarioId,
    required String dataInicial,
    required String dataFinal,
  });
}
