import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/core/domain/models/user_model.dart';
import 'package:posto360/modules/equipe/domain/models/campanhas_resumo_model.dart';
import 'package:posto360/modules/equipe/domain/models/checklists_resumo_model.dart';
import 'package:posto360/modules/equipe/domain/models/cursos_resumo_model.dart';
import 'package:posto360/modules/equipe/domain/models/membro_equipe_model.dart';
import 'package:posto360/modules/equipe/domain/models/resumo_equipe_model.dart';

abstract class EquipeService {
  Future<ResultActionDTO<ResumoEquipeModel>> getResumo({
    required DateTime dataAtual,
    required int filialId,
  });
  Future<ResultActionDTO<List<MembroEquipeModel>>> getMembros({
    required DateTime dataAtual,
    required int filialId,
  });
  Future<ResultActionDTO<UserModel>> getColaborador({required String id});
  Future<ResultActionDTO<CampanhasResumoModel>> getCampanhasResumo({
    required int funcionarioCodigo,
    required List<int> idsCampanhas,
    required DateTime dataAtual,
  });
  Future<ResultActionDTO<CursosResumoModel>> getCursosResumo({
    required int funcionarioCodigo,
    required DateTime dataAtual,
  });
  Future<ResultActionDTO<ChecklistsResumoModel>> getChecklistsResumo({
    required int funcionarioCodigo,
    required DateTime dataAtual,
  });
}
