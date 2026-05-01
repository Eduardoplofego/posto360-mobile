import 'package:posto360/modules/chamados/domain/models/chamado_campo_model.dart';
import 'package:posto360/modules/chamados/domain/models/chamado_model.dart';
import 'package:posto360/modules/chamados/domain/models/chamado_template_model.dart';
import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';

abstract class ChamadosRepository {
  Future<ResultActionDTO<List<ChamadoModel>>> getChamadosAbertos({
    required int filialId,
    required int empresaId,
  });

  Future<ResultActionDTO<List<ChamadoCampoModel>>> getCamposChamado({
    required int chamadoId,
  });

  Future<ResultActionDTO<List<ChamadoTemplateModel>>> getTemplatesAbrirChamado({
    required int empresaId,
  });

  Future<ResultActionDTO<int?>> abrirChamado({
    required int templateId,
    required String abertoPor,
    required String titulo,
    required int filialId,
    required int empresaId,
  });

  Future<ResultActionDTO<bool>> atualizarCampos({
    required int chamadoId,
    required List<Map<String, dynamic>> campos,
  });
}
