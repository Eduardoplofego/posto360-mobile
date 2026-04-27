import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/dash/domain/models/avaliacao_model.dart';

abstract class AvaliacoesRepository {
  Future<ResultActionDTO<AvaliacaoModel>> getAvaliacoes({
    required String funcionarioId,
    required String dataInicial,
    required String dataFinal,
  });
}
