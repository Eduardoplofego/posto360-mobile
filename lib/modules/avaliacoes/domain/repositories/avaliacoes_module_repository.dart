import 'package:posto360/modules/avaliacoes/domain/models/avaliacao_details_model.dart';
import 'package:posto360/modules/avaliacoes/domain/models/avaliacoes_avaliador_model.dart';
import 'package:posto360/modules/avaliacoes/domain/models/avaliacoes_model.dart';
import 'package:posto360/modules/avaliacoes/domain/models/user_model.dart';
import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';

abstract class AvaliacoesModuleRepository {
  Future<ResultActionDTO<List<AvaliacoesModel>>> getAvaliacoesAvaliado({
    required String dataInicial,
    required String dataFinal,
    required String usuarioId,
  });
  Future<ResultActionDTO<List<AvaliacaoDetailsModel>>> getCriterios({
    required int gestaoAvaliacaoId,
    required int modeloAvaliacaoId,
  });
  Future<ResultActionDTO<List<AvaliacaoAvaliador>>> getAvaliadorFinalizadas({
    required String dataInicial,
    required String dataFinal,
    required String usuarioId,
  });
  Future<ResultActionDTO<List<AvaliacaoAvaliador>>> getAvaliadorPendentes({
    required String dataAtual,
    required String usuarioId,
  });
  Future<ResultActionDTO<List<UserAvaliationModel>>> getUsers({
    required int avaliacaoId,
  });
  Future<ResultActionDTO<String>> setUser({
    required int avaliacaoId,
    required String usuarioId,
  });
}
