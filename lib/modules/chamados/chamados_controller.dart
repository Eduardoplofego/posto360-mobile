import 'package:get/get.dart';
import 'package:posto360/modules/chamados/domain/models/chamado_model.dart';
import 'package:posto360/modules/chamados/infra/services/chamados_service.dart';
import 'package:posto360/modules/core/domain/services/auth_service.dart';

class ChamadosController extends GetxController {
  final ChamadosService _chamadosService;

  ChamadosController({required ChamadosService chamadosService})
    : _chamadosService = chamadosService;

  final _loading = false.obs;
  final _errorMessage = ''.obs;
  final _chamados = <ChamadoModel>[].obs;

  bool get isLoading => _loading.value;
  String get errorMessage => _errorMessage.value;
  bool get hasError => _errorMessage.value.isNotEmpty;
  List<ChamadoModel> get chamados => _chamados.toList();

  @override
  Future<void> onReady() async {
    super.onReady();
    await _loadChamados();
  }

  Future<void> onRefresh() async {
    await _loadChamados();
  }

  Future<void> _loadChamados() async {
    _loading.value = true;
    _errorMessage.value = '';
    final user = Get.find<AuthService>().authenticatedUser;
    if (user == null) {
      _errorMessage.value = 'Usuário não autenticado.';
      _loading.value = false;
      return;
    }
    if (user.idFilial == null) {
      _errorMessage.value = 'Filial não definida para o usuário.';
      _loading.value = false;
      return;
    }
    final result = await _chamadosService.getChamadosAbertos(
      filialId: user.idFilial!,
      empresaId: user.idEmpresa,
    );
    if (result.success) {
      _chamados.assignAll(result.data ?? []);
    } else {
      _errorMessage.value = result.message;
      _chamados.clear();
    }
    _loading.value = false;
  }
}
