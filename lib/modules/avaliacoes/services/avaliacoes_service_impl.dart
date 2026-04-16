import 'package:posto360/modules/avaliacoes/domain/models/avaliacao_details_model.dart';
import 'package:posto360/modules/avaliacoes/domain/models/avaliacoes_model.dart';
import 'package:posto360/modules/avaliacoes/domain/repositories/avaliacoes_module_repository.dart';
import 'package:posto360/modules/avaliacoes/infra/services/avaliacoes_module_service.dart';

import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/core/domain/helpers/date_helper.dart';
import 'package:posto360/modules/core/domain/utils/data_formatters.dart';

class AvaliacoesModuleServiceImpl extends AvaliacoesModuleService {
  final AvaliacoesModuleRepository _repository;

  AvaliacoesModuleServiceImpl(this._repository);

  @override
  Future<ResultActionDTO<List<AvaliacoesModel>>> getAvaliacoesAvaliado({
    required DateTime dataMes,
    required String usuarioId,
  }) async {
    final (dataInicial, dataFinal) = DateHelper.getInitialAndLastCurrentDate(
      dataMes,
    );
    return await _repository.getAvaliacoesAvaliado(
      dataInicial: DataFormatters.formatarData(dataInicial),
      dataFinal: DataFormatters.formatarData(dataFinal),
      usuarioId: usuarioId,
    );
  }

  @override
  Future<ResultActionDTO<List<AvaliacaoDetailsModel>>> getCriterios({
    required int gestaoAvaliacaoId,
    required int modeloAvaliacaoId,
  }) async {
    return await _repository.getCriterios(
      gestaoAvaliacaoId: gestaoAvaliacaoId,
      modeloAvaliacaoId: modeloAvaliacaoId,
    );
  }
}
