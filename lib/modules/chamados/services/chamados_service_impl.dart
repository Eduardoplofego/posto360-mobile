import 'package:posto360/modules/chamados/domain/models/chamado_campo_model.dart';
import 'package:posto360/modules/chamados/domain/models/chamado_model.dart';
import 'package:posto360/modules/chamados/domain/models/chamado_template_model.dart';
import 'package:posto360/modules/chamados/domain/repositories/chamados_repository.dart';
import 'package:posto360/modules/chamados/infra/services/chamados_service.dart';
import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';

class ChamadosServiceImpl extends ChamadosService {
  final ChamadosRepository _chamadosRepository;

  ChamadosServiceImpl({required ChamadosRepository chamadosRepository})
    : _chamadosRepository = chamadosRepository;

  @override
  Future<ResultActionDTO<List<ChamadoModel>>> getChamadosAbertos({
    required int filialId,
    required int empresaId,
  }) async => await _chamadosRepository.getChamadosAbertos(
    filialId: filialId,
    empresaId: empresaId,
  );

  @override
  Future<ResultActionDTO<List<ChamadoCampoModel>>> getCamposChamado({
    required int chamadoId,
  }) async =>
      await _chamadosRepository.getCamposChamado(chamadoId: chamadoId);

  @override
  Future<ResultActionDTO<List<ChamadoTemplateModel>>> getTemplatesAbrirChamado({
    required int empresaId,
  }) async =>
      await _chamadosRepository.getTemplatesAbrirChamado(empresaId: empresaId);

  @override
  Future<ResultActionDTO<int?>> abrirChamado({
    required int templateId,
    required String abertoPor,
    required String titulo,
    required int filialId,
    required int empresaId,
  }) async => await _chamadosRepository.abrirChamado(
    templateId: templateId,
    abertoPor: abertoPor,
    titulo: titulo,
    filialId: filialId,
    empresaId: empresaId,
  );

  @override
  Future<ResultActionDTO<bool>> atualizarCampos({
    required int chamadoId,
    required List<Map<String, dynamic>> campos,
  }) async =>
      await _chamadosRepository.atualizarCampos(
        chamadoId: chamadoId,
        campos: campos,
      );
}
