import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/procedimentos/domain/models/procedimento_model.dart';

abstract class ProcedimentosService {
  Future<ResultActionDTO<List<ProcedimentoModel>>> getProcedimentos({
    required String userId,
  });

  Future<ResultActionDTO<ProcedimentoModel?>> getProcedimentoDetalhe({
    required String userId,
    required int procedimentoId,
  });
}
