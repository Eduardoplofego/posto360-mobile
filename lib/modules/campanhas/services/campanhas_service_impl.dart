import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/core/domain/helpers/date_helper.dart';
import 'package:posto360/modules/core/domain/utils/data_formatters.dart';
import 'package:posto360/modules/campanhas/domain/models/campanha_model.dart';
import 'package:posto360/modules/campanhas/domain/repositories/app_campanhas_repository.dart';

import '../infra/services/app_campanhas_service.dart';

class CampanhasServiceImpl extends AppCampanhasService {
  final AppCampanhasRepository _repository;

  CampanhasServiceImpl({required AppCampanhasRepository campanhaRepository})
    : _repository = campanhaRepository;

  @override
  Future<ResultActionDTO<List<CampanhaModel>>> getAllCampanhas({
    required int filialId,
    required String usuarioId,
    required int empresaId,
    required DateTime data,
  }) async {
    final (dataInicial, dataFinal) = DateHelper.getInitialAndLastCurrentDate(
      data,
    );
    final result = await _repository.getAllCampanhas(
      filialId: filialId,
      usuarioId: usuarioId,
      empresaId: empresaId,
      dataInicial: DataFormatters.formatarData(dataInicial),
      dataFinal: DataFormatters.formatarData(dataFinal),
    );
    return result;
  }
}
