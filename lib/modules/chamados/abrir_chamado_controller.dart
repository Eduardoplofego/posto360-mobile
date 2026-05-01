import 'package:get/get.dart';
import 'package:posto360/modules/chamados/domain/models/chamado_template_model.dart';
import 'package:posto360/modules/chamados/infra/services/chamados_service.dart';
import 'package:posto360/modules/core/domain/services/auth_service.dart';

class AbrirChamadoController extends GetxController {
  final ChamadosService _chamadosService;

  AbrirChamadoController({required ChamadosService chamadosService})
    : _chamadosService = chamadosService;

  final _loading = false.obs;
  final _submitting = false.obs;
  final _errorMessage = ''.obs;
  final _templates = <ChamadoTemplateModel>[].obs;

  bool get isLoading => _loading.value;
  bool get isSubmitting => _submitting.value;
  String get errorMessage => _errorMessage.value;
  bool get hasError => _errorMessage.value.isNotEmpty;
  List<ChamadoTemplateModel> get templates => _templates.toList();

  @override
  Future<void> onReady() async {
    super.onReady();
    await _loadTemplates();
  }

  Future<void> onRefresh() async {
    await _loadTemplates();
  }

  Future<void> _loadTemplates() async {
    _loading.value = true;
    _errorMessage.value = '';
    final user = Get.find<AuthService>().authenticatedUser;
    if (user == null) {
      _errorMessage.value = 'Usuário não autenticado.';
      _loading.value = false;
      return;
    }
    final result = await _chamadosService.getTemplatesAbrirChamado(
      empresaId: user.idEmpresa,
    );
    if (result.success) {
      _templates.assignAll(result.data ?? []);
    } else {
      _errorMessage.value = result.message;
      _templates.clear();
    }
    _loading.value = false;
  }

  Future<({bool ok, String? error, int? chamadoId})> abrir({
    required ChamadoTemplateModel template,
    required String titulo,
  }) async {
    final tituloTrim = titulo.trim();
    if (tituloTrim.isEmpty) {
      return (ok: false, error: 'Informe um título para o chamado.', chamadoId: null);
    }
    final user = Get.find<AuthService>().authenticatedUser;
    if (user == null) {
      return (ok: false, error: 'Usuário não autenticado.', chamadoId: null);
    }
    if (user.idFilial == null) {
      return (
        ok: false,
        error: 'Filial não definida para o usuário.',
        chamadoId: null,
      );
    }
    _submitting.value = true;
    final result = await _chamadosService.abrirChamado(
      templateId: template.id,
      abertoPor: user.id,
      titulo: tituloTrim,
      filialId: user.idFilial!,
      empresaId: user.idEmpresa,
    );
    _submitting.value = false;
    if (result.success) {
      return (ok: true, error: null, chamadoId: result.data);
    }
    return (ok: false, error: result.message, chamadoId: null);
  }
}
