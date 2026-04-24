import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/core/domain/helpers/date_helper.dart';
import 'package:posto360/modules/core/domain/models/user_model.dart';
import 'package:posto360/modules/core/domain/utils/data_formatters.dart';
import 'package:posto360/modules/equipe/domain/models/membro_equipe_model.dart';
import 'package:posto360/modules/equipe/domain/models/resumo_equipe_model.dart';
import 'package:posto360/modules/equipe/domain/repositories/equipe_repository.dart';
import 'package:posto360/modules/equipe/infra/services/equipe_service.dart';

class EquipeServiceImpl extends EquipeService {
  final EquipeRepository _equipeRepository;

  EquipeServiceImpl({required EquipeRepository equipeRepository})
    : _equipeRepository = equipeRepository;

  @override
  Future<ResultActionDTO<ResumoEquipeModel>> getResumo({
    required DateTime dataAtual,
    required int filialId,
  }) {
    final (dataInicial, dataFinal) = DateHelper.getInitialAndLastCurrentDate(
      dataAtual,
    );
    return _equipeRepository.getResumo(
      dataInicial: DataFormatters.formatarData(dataInicial),
      dataFinal: DataFormatters.formatarData(dataFinal),
      filialId: filialId,
    );
  }

  @override
  Future<ResultActionDTO<List<MembroEquipeModel>>> getMembros({
    required DateTime dataAtual,
    required int filialId,
  }) {
    final (dataInicial, dataFinal) = DateHelper.getInitialAndLastCurrentDate(
      dataAtual,
    );
    return _equipeRepository.getMembros(
      dataInicial: DataFormatters.formatarData(dataInicial),
      dataFinal: DataFormatters.formatarData(dataFinal),
      filialId: filialId,
    );
  }

  @override
  Future<ResultActionDTO<UserModel>> getColaborador({required String id}) =>
      _equipeRepository.getColaborador(id: id);
}
