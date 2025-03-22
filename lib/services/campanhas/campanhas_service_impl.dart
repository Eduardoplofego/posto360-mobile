import 'package:posto360/core/dto/result_action_dto.dart';
import 'package:posto360/models/campanha_model.dart';
import 'package:posto360/repositories/campanhas/campanhas_repository.dart';

import './campanhas_service.dart';

class CampanhasServiceImpl extends CampanhasService {
  final CampanhasRepository _repository;

  CampanhasServiceImpl({required CampanhasRepository campanhaRepository})
    : _repository = campanhaRepository;

  @override
  Future<ResultActionDTO<List<CampanhaModel>>> getAllCampanhas({
    required int filialId,
    required String tipoUsuario,
  }) async => await _repository.getAllCampanhas(
    filialId: filialId,
    tipoUsuario: tipoUsuario,
  );
}
