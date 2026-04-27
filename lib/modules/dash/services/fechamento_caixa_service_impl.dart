import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/core/domain/helpers/date_helper.dart';
import 'package:posto360/modules/core/domain/utils/data_formatters.dart';
import 'package:posto360/modules/dash/domain/models/cartoes_model.dart';
import 'package:posto360/modules/dash/domain/repositories/fechamento_caixa_repository.dart';
import '../infra/services/fechamento_caixa_service.dart';

class FechamentoCaixaServiceImpl extends FechamentoCaixaService {
  final FechamentoCaixaRepository _fechamentoCaixaRepository;

  FechamentoCaixaServiceImpl({
    required FechamentoCaixaRepository fechamentoCaixaRepository,
  }) : _fechamentoCaixaRepository = fechamentoCaixaRepository;

  @override
  Future<ResultActionDTO<CartoesModel>> getFechamento({
    required String usuarioId,
    required DateTime dataMes,
  }) async {
    final (dataInicial, dataFinal) = DateHelper.getInitialAndLastCurrentDate(
      dataMes,
    );

    final result = await _fechamentoCaixaRepository.getFechamento(
      usuarioId: usuarioId,
      dataInicial: DataFormatters.formatarData(dataInicial),
      dataFinal: DataFormatters.formatarData(dataFinal),
    );

    if (result.isError) {
      return result;
    }

    return result;
  }
}
