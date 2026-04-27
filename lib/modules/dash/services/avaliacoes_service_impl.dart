import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/core/domain/helpers/date_helper.dart';
import 'package:posto360/modules/core/domain/utils/data_formatters.dart';
import 'package:posto360/modules/dash/domain/models/avaliacao_model.dart';
import 'package:posto360/modules/dash/domain/repositories/avaliacoes_repository.dart';
import '../infra/services/avaliacoes_service.dart';

class AvaliacoesServiceImpl implements AvaliacoesService {
  final AvaliacoesRepository _repository;

  AvaliacoesServiceImpl(this._repository);
  @override
  Future<ResultActionDTO<AvaliacaoModel>> getAvaliacoes({
    required String funcionarioId,
    required DateTime dataMes,
  }) async {
    final (dataInicial, dataFinal) = DateHelper.getInitialAndLastCurrentDate(
      dataMes,
    );
    return await _repository.getAvaliacoes(
      funcionarioId: funcionarioId,
      dataInicial: DataFormatters.formatarData(dataInicial),
      dataFinal: DataFormatters.formatarData(dataFinal),
    );
  }
}
