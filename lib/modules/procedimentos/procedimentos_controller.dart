import 'package:get/get.dart';
import 'package:posto360/modules/core/domain/services/auth_service.dart';
import 'package:posto360/modules/procedimentos/domain/models/procedimento_model.dart';
import 'package:posto360/modules/procedimentos/infra/services/procedimentos_service.dart';

class ProcedimentosController extends GetxController {
  final ProcedimentosService _procedimentosService;

  ProcedimentosController({
    required ProcedimentosService procedimentosService,
  }) : _procedimentosService = procedimentosService;

  final _loading = false.obs;
  final _errorMessage = ''.obs;
  final _procedimentos = <ProcedimentoModel>[].obs;

  bool get isLoading => _loading.value;
  String get errorMessage => _errorMessage.value;
  bool get hasError => _errorMessage.value.isNotEmpty;
  List<ProcedimentoModel> get procedimentos => _procedimentos.toList();

  @override
  Future<void> onReady() async {
    super.onReady();
    await _loadProcedimentos();
  }

  Future<void> onRefresh() async {
    await _loadProcedimentos();
  }

  Future<void> _loadProcedimentos() async {
    _loading.value = true;
    _errorMessage.value = '';
    final user = Get.find<AuthService>().authenticatedUser;
    if (user == null) {
      _errorMessage.value = 'Usuário não autenticado.';
      _loading.value = false;
      return;
    }
    final result = await _procedimentosService.getProcedimentos(
      userId: user.id,
    );
    if (result.success) {
      _procedimentos.assignAll(result.data ?? []);
    } else {
      _errorMessage.value = result.message;
      _procedimentos.clear();
    }
    _loading.value = false;
  }
}
