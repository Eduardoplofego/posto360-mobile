import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/fechamento-caixa/domain/models/cartoes_model.dart';
import 'package:posto360/modules/fechamento-caixa/domain/repositories/fechamento_caixa_repository.dart';
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
    final dataInicial = '${dataMes.year}-${dataMes.month}-${01}';
    final lastDayMonth =
        DateTime(
          dataMes.year,
          dataMes.month + 1,
          1,
        ).subtract(Duration(days: 1)).day;
    final dataFinal = '${dataMes.year}-${dataMes.month}-$lastDayMonth';

    final result = await _fechamentoCaixaRepository.getFechamento(
      usuarioId: usuarioId,
      dataInicial: dataInicial,
      dataFinal: dataFinal,
    );

    if (result.isError) {
      return result;
    }

    return result;
  }
}
