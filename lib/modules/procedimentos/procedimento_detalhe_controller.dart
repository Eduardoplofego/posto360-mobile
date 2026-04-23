import 'package:get/get.dart';
import 'package:posto360/modules/core/domain/services/auth_service.dart';
import 'package:posto360/modules/procedimentos/domain/models/procedimento_model.dart';
import 'package:posto360/modules/procedimentos/infra/services/procedimentos_service.dart';

class ProcedimentoDetalheController extends GetxController {
  final int procedimentoId;
  final ProcedimentosService _procedimentosService;

  ProcedimentoDetalheController({
    required this.procedimentoId,
    required ProcedimentosService procedimentosService,
  }) : _procedimentosService = procedimentosService;

  final _loading = false.obs;
  final _errorMessage = ''.obs;
  final _procedimento = Rxn<ProcedimentoModel>();
  final _expanded = <int>{}.obs;

  bool get isLoading => _loading.value;
  String get errorMessage => _errorMessage.value;
  bool get hasError => _errorMessage.value.isNotEmpty;
  ProcedimentoModel? get procedimento => _procedimento.value;
  Set<int> get expandedEtapas => _expanded;

  @override
  Future<void> onReady() async {
    super.onReady();
    await _loadDetalhe();
  }

  Future<void> onRefresh() async {
    await _loadDetalhe();
  }

  Future<void> _loadDetalhe() async {
    _loading.value = true;
    _errorMessage.value = '';
    final user = Get.find<AuthService>().authenticatedUser;
    if (user == null) {
      _errorMessage.value = 'Usuário não autenticado.';
      _loading.value = false;
      return;
    }
    final result = await _procedimentosService.getProcedimentoDetalhe(
      userId: user.id,
      procedimentoId: procedimentoId,
    );
    if (result.success) {
      final model = result.data;
      _procedimento.value = model;
      _expanded.clear();
      if (model != null && model.etapas.isNotEmpty) {
        _expanded.add(model.etapas.first.id);
      }
    } else {
      _errorMessage.value = result.message;
      _procedimento.value = null;
    }
    _loading.value = false;
  }

  bool isEtapaExpanded(int etapaId) => _expanded.contains(etapaId);

  void toggleEtapa(int etapaId) {
    if (_expanded.contains(etapaId)) {
      _expanded.remove(etapaId);
    } else {
      _expanded.add(etapaId);
    }
  }
}
