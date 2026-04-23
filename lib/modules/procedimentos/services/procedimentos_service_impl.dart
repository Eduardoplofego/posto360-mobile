import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/procedimentos/domain/models/procedimento_model.dart';
import 'package:posto360/modules/procedimentos/domain/repositories/procedimentos_repository.dart';
import 'package:posto360/modules/procedimentos/infra/services/procedimentos_service.dart';

class ProcedimentosServiceImpl extends ProcedimentosService {
  final ProcedimentosRepository _procedimentosRepository;

  ProcedimentosServiceImpl({
    required ProcedimentosRepository procedimentosRepository,
  }) : _procedimentosRepository = procedimentosRepository;

  @override
  Future<ResultActionDTO<List<ProcedimentoModel>>> getProcedimentos({
    required String userId,
  }) async =>
      await _procedimentosRepository.getProcedimentos(userId: userId);

  @override
  Future<ResultActionDTO<ProcedimentoModel?>> getProcedimentoDetalhe({
    required String userId,
    required int procedimentoId,
  }) async {
    final result = await _procedimentosRepository.getProcedimentosDetalhes(
      userId: userId,
      procedimentoIds: [procedimentoId],
    );
    if (result.isError) {
      return ResultActionDTO.failure(result.message, null);
    }
    final list = result.data ?? [];
    final procedimento = list.firstWhere(
      (p) => p.id == procedimentoId,
      orElse: () =>
          list.isNotEmpty
              ? list.first
              : ProcedimentoModel(
                id: 0,
                nome: '',
                descricao: '',
                createdAt: null,
                etapas: const [],
              ),
    );
    if (procedimento.id == 0) {
      return ResultActionDTO.success(data: null);
    }
    return ResultActionDTO.success(data: procedimento);
  }
}
