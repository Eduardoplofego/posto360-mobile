import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/core/domain/models/user_model.dart';
import 'package:posto360/modules/equipe/domain/models/membro_equipe_model.dart';
import 'package:posto360/modules/equipe/domain/models/resumo_equipe_model.dart';

abstract class EquipeRepository {
  Future<ResultActionDTO<ResumoEquipeModel>> getResumo({
    required String dataInicial,
    required String dataFinal,
    required int filialId,
  });
  Future<ResultActionDTO<List<MembroEquipeModel>>> getMembros({
    required String dataInicial,
    required String dataFinal,
    required int filialId,
  });
  Future<ResultActionDTO<UserModel>> getColaborador({required String id});
}
