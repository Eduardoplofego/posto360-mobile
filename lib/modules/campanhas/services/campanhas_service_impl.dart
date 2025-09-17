import 'package:posto360/core/dto/result_action_dto.dart';
import 'package:posto360/core/utils/data_formatters.dart';
import 'package:posto360/models/campanha_model.dart';
import 'package:posto360/modules/campanhas/domain/repositories/campanhas_repository.dart';

import '../infra/services/campanhas_service.dart';

class CampanhasServiceImpl extends CampanhasService {
  final CampanhasRepository _repository;

  CampanhasServiceImpl({required CampanhasRepository campanhaRepository})
    : _repository = campanhaRepository;

  @override
  Future<ResultActionDTO<List<CampanhaModel>>> getAllCampanhas({
    required int filialId,
    required String tipoUsuario,
    required DateTime data,
  }) async {
    final dataFormatada = DataFormatters.formatarData(data);
    final result = await _repository.getAllCampanhas(
      filialId: filialId,
      tipoUsuario: tipoUsuario,
      data: dataFormatada,
    );
    return result;
  }
}
