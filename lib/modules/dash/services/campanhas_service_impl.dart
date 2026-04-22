import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/dash/domain/models/campanha_model.dart';
import 'package:posto360/modules/dash/domain/repositories/campanhas_repository.dart';

import '../infra/services/campanhas_service.dart';

class CampanhasServiceImpl extends CampanhasService {
  final CampanhasRepository _repository;

  CampanhasServiceImpl({required CampanhasRepository campanhaRepository})
    : _repository = campanhaRepository;

  @override
  Future<ResultActionDTO<List<CampanhaModel>>> getAllCampanhas({
    required List<int> campanhasIds,
  }) async {
    // final dataFormatada = DataFormatters.formatarData(data);
    final campanhas = <CampanhaModel>[];
    for (var id in campanhasIds) {
      final result = await _repository.getCampanha(campanhaId: id);
      if (result.isError) {
        return ResultActionDTO.failure(result.message, null);
      }
      campanhas.add(result.data!);
    }

    return ResultActionDTO.success(data: campanhas);
  }
}
