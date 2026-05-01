import 'package:get/get.dart';
import 'package:posto360/modules/chamados/domain/models/chamado_campo_model.dart';
import 'package:posto360/modules/chamados/domain/models/chamado_model.dart';
import 'package:posto360/modules/chamados/infra/services/chamados_service.dart';

class ChamadoDetalheController extends GetxController {
  final int chamadoId;
  final ChamadoModel? chamadoArg;
  final ChamadosService _chamadosService;

  ChamadoDetalheController({
    required this.chamadoId,
    required this.chamadoArg,
    required ChamadosService chamadosService,
  }) : _chamadosService = chamadosService;

  final _loading = false.obs;
  final _errorMessage = ''.obs;
  final _campos = <ChamadoCampoModel>[].obs;

  bool get isLoading => _loading.value;
  String get errorMessage => _errorMessage.value;
  bool get hasError => _errorMessage.value.isNotEmpty;
  List<ChamadoCampoModel> get campos => _campos.toList();
  ChamadoModel? get chamado => chamadoArg;

  @override
  Future<void> onReady() async {
    super.onReady();
    await _loadCampos();
  }

  Future<void> onRefresh() async {
    await _loadCampos();
  }

  Future<void> _loadCampos() async {
    _loading.value = true;
    _errorMessage.value = '';
    if (chamadoId == 0) {
      _errorMessage.value = 'Chamado inválido.';
      _loading.value = false;
      return;
    }
    final result = await _chamadosService.getCamposChamado(
      chamadoId: chamadoId,
    );
    if (result.success) {
      _campos.assignAll(result.data ?? []);
    } else {
      _errorMessage.value = result.message;
      _campos.clear();
    }
    _loading.value = false;
  }
}
