import 'package:get/get.dart';
import 'package:posto360/modules/core/domain/services/auth_service.dart';
import 'package:posto360/modules/equipe/domain/models/membro_equipe_model.dart';
import 'package:posto360/modules/equipe/infra/services/equipe_service.dart';

class EquipeController extends GetxController {
  final EquipeService _equipeService;

  EquipeController({required EquipeService equipeService})
    : _equipeService = equipeService;

  final _loading = false.obs;
  final _errorMessage = ''.obs;
  final _membros = <MembroEquipeModel>[].obs;

  bool get isLoading => _loading.value;
  String get errorMessage => _errorMessage.value;
  bool get hasError => _errorMessage.value.isNotEmpty;
  List<MembroEquipeModel> get membros => _membros.toList();

  @override
  Future<void> onReady() async {
    super.onReady();
    await _load();
  }

  Future<void> onRefresh() async => _load();

  DateTime _monthFromRoute() {
    final raw = Get.parameters['month'];
    if (raw == null) return DateTime.now();
    return DateTime.tryParse(raw) ?? DateTime.now();
  }

  Future<void> _load() async {
    _loading.value = true;
    _errorMessage.value = '';
    final user = Get.find<AuthService>().getUser();
    final filialId = user?.idFilial;
    if (filialId == null) {
      _errorMessage.value = 'Filial do gerente não encontrada.';
      _membros.clear();
      _loading.value = false;
      return;
    }
    final result = await _equipeService.getMembros(
      dataAtual: _monthFromRoute(),
      filialId: filialId,
    );
    if (result.success) {
      _membros.assignAll(result.data ?? []);
    } else {
      _errorMessage.value = result.message;
      _membros.clear();
    }
    _loading.value = false;
  }
}
