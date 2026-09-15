import 'package:get/get.dart';
import 'package:posto360/modules/chamados/domain/models/chamado_template_model.dart';
import 'package:posto360/modules/chamados/infra/services/chamados_service.dart';
import 'package:posto360/modules/core/domain/services/auth_service.dart';
import 'package:posto360/modules/core/domain/services/filiais_acesso_service.dart';

class AbrirChamadoController extends GetxController {
  final ChamadosService _chamadosService;

  AbrirChamadoController({required ChamadosService chamadosService})
    : _chamadosService = chamadosService;

  final _loading = false.obs;
  final _submitting = false.obs;
  final _errorMessage = ''.obs;
  final _templates = <ChamadoTemplateModel>[].obs;
  final _filiais = <FilialAcessoModel>[].obs;
  final _filialSelecionadaId = RxnInt();

  bool get isLoading => _loading.value;
  bool get isSubmitting => _submitting.value;
  String get errorMessage => _errorMessage.value;
  bool get hasError => _errorMessage.value.isNotEmpty;
  List<ChamadoTemplateModel> get templates => _templates.toList();

  /// O motorista atende varias filiais, entao ele escolhe onde o chamado sera
  /// aberto. Os demais perfis tem uma filial so, vinda do proprio cadastro.
  bool get precisaEscolherFilial =>
      Get.find<AuthService>().authenticatedUser?.isMotorista ?? false;
  List<FilialAcessoModel> get filiais => _filiais.toList();
  int? get filialSelecionadaId => _filialSelecionadaId.value;

  String? get filialSelecionadaNome {
    final id = _filialSelecionadaId.value;
    if (id == null) return null;
    for (final filial in _filiais) {
      if (filial.id == id) return filial.nome;
    }
    return null;
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    _carregarFiliais();
    await _loadTemplates();
  }

  Future<void> onRefresh() async {
    _carregarFiliais();
    await _loadTemplates();
  }

  void selecionarFilial(int? filialId) {
    _filialSelecionadaId.value = filialId;
  }

  void _carregarFiliais() {
    final user = Get.find<AuthService>().authenticatedUser;
    if (user == null || !user.isMotorista) {
      _filiais.clear();
      _filialSelecionadaId.value = null;
      return;
    }
    final disponiveis = Get.find<FiliaisAcessoService>().filiais;
    _filiais.assignAll(disponiveis);
    if (disponiveis.length == 1) {
      _filialSelecionadaId.value = disponiveis.first.id;
      return;
    }
    final selecionada = _filialSelecionadaId.value;
    final aindaExiste = disponiveis.any((f) => f.id == selecionada);
    if (!aindaExiste) _filialSelecionadaId.value = null;
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

  /// Mensagem de bloqueio quando ainda nao da para abrir o chamado, ou null
  /// quando esta tudo certo para enviar.
  String? get impedimentoParaAbrir {
    final user = Get.find<AuthService>().authenticatedUser;
    if (user == null) return 'Usuário não autenticado.';
    if (!user.isMotorista) {
      return user.idFilial == null ? 'Filial não definida para o usuário.' : null;
    }
    if (_filiais.isEmpty) {
      return 'Nenhuma filial disponível para abrir chamado.';
    }
    if (_filialSelecionadaId.value == null) {
      return 'Escolha a filial do chamado antes de continuar.';
    }
    return null;
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
    final impedimento = impedimentoParaAbrir;
    if (impedimento != null) {
      return (ok: false, error: impedimento, chamadoId: null);
    }
    final filialId =
        user.isMotorista ? _filialSelecionadaId.value! : user.idFilial!;
    _submitting.value = true;
    final result = await _chamadosService.abrirChamado(
      templateId: template.id,
      abertoPor: user.id,
      titulo: tituloTrim,
      filialId: filialId,
      empresaId: user.idEmpresa,
    );
    _submitting.value = false;
    if (result.success) {
      return (ok: true, error: null, chamadoId: result.data);
    }
    return (ok: false, error: result.message, chamadoId: null);
  }
}
