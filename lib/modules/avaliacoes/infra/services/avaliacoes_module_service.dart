import 'package:posto360/modules/avaliacoes/domain/models/avaliacao_details_model.dart';
import 'package:posto360/modules/avaliacoes/domain/models/avaliacoes_model.dart';
import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';

abstract class AvaliacoesModuleService {
  Future<ResultActionDTO<List<AvaliacoesModel>>> getAvaliacoesAvaliado({
    required DateTime dataMes,
    required String usuarioId,
  });
  Future<ResultActionDTO<List<AvaliacaoDetailsModel>>> getCriterios({
    required int gestaoAvaliacaoId,
    required int modeloAvaliacaoId,
  });
}
