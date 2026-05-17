import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/core/domain/services/auth_service.dart';
import 'package:posto360/modules/motoristas/domain/models/dashboard_motorista_model.dart';
import 'package:posto360/modules/motoristas/domain/models/filial_motorista_model.dart';
import 'package:posto360/modules/motoristas/infra/services/motoristas_service.dart';

class MotoristasController extends GetxController {
  final MotoristasService _motoristasService;

  MotoristasController({required MotoristasService motoristasService})
      : _motoristasService = motoristasService;

  final _loading = false.obs;
  final _errorMessage = RxnString();
  final _dashboard = Rxn<DashboardMotoristaModel>();
  final _dataSelecionada = DateTime.now().obs;

  bool get isLoading => _loading.value;
  String? get errorMessage => _errorMessage.value;
  bool get hasError => _errorMessage.value != null;
  DateTime get dataSelecionada => _dataSelecionada.value;
  List<FilialMotoristaModel> get filiais =>
      _dashboard.value?.filiais.where((f) => f.hasProdutos).toList() ?? [];
  bool get hasFiliais => filiais.isNotEmpty;

  @override
  void onReady() {
    super.onReady();
    _loadDashboard();
  }

  Future<void> onRefresh() async {
    await _loadDashboard();
  }

  Future<ResultActionDTO<String>> onSavePhoto(String path) async {
    return ResultActionDTO.failure(
      'Alteração de foto não disponível neste perfil',
      '',
    );
  }

  Future<void> _loadDashboard() async {
    final userAuth = Get.find<AuthService>().authenticatedUser;
    if (userAuth == null) {
      debugPrint('[motoristas] sem usuário autenticado — abortando load');
      _errorMessage.value = 'Sessão expirada. Faça login novamente.';
      return;
    }

    debugPrint(
      '[motoristas] carregando dashboard motoristaId=${userAuth.id} data=${_dataSelecionada.value.toIso8601String()}',
    );

    _errorMessage.value = null;
    _loading(true);
    final result = await _motoristasService.getDashboard(
      motoristaId: userAuth.id,
      data: _dataSelecionada.value,
    );
    _loading(false);

    if (result.isError) {
      debugPrint('[motoristas] erro: ${result.message}');
      _errorMessage.value = result.message;
      return;
    }

    final totalFiliais = result.data?.filiais.length ?? 0;
    final comProdutos =
        result.data?.filiais.where((f) => f.hasProdutos).length ?? 0;
    debugPrint(
      '[motoristas] resposta ok: $totalFiliais filiais recebidas, $comProdutos com produtos',
    );
    _dashboard.value = result.data;
  }
}
