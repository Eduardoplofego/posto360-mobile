import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/fechamento-caixa/domain/models/cartoes_model.dart';
import 'package:posto360/modules/fechamento-caixa/domain/models/detalhes_cartoes_model.dart';

abstract class AppFechamentoCaixaRepository {
  Future<ResultActionDTO<CartoesModel>> getFechamento({
    required String usuarioId,
    required String dataInicial,
    required String dataFinal,
  });
  Future<ResultActionDTO<List<DetalhesCartoesModel>>> getFechamentoDetalhes({
    required String usuarioId,
    required String dataMes,
  });
}
