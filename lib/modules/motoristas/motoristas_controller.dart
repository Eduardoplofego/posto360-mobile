import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:posto360/modules/core/domain/constants/constants.dart';
import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/core/domain/models/user_model.dart';
import 'package:posto360/modules/core/domain/services/auth_service.dart';
import 'package:posto360/modules/core/domain/services/filiais_acesso_service.dart';
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
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _currentTab = 0.obs;

  int get currentTab => _currentTab.value;
  void changeTab(int index) => _currentTab.value = index;

  UserModel get autheticatedUser =>
      Get.find<AuthService>().authenticatedUser ?? UserModel.empty();

  String get nameUser =>
      autheticatedUser.name + (autheticatedUser.lastName ?? '');

  String get photoUrl {
    final photoStorage = GetStorage().read(Constants.USER_PHOTO_URL);
    if (photoStorage != null) return photoStorage;
    return autheticatedUser.photoUrl ?? '';
  }

  bool get isLoading => _loading.value;
  String? get errorMessage => _errorMessage.value;
  bool get hasError => _errorMessage.value != null;
  DateTime get dataSelecionada => _dataSelecionada.value;
  List<FilialMotoristaModel> get filiais =>
      _dashboard.value?.filiais.where((f) => f.isVisivel).toList() ?? [];
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
    final exibidas =
        result.data?.filiais.where((f) => f.isVisivel).length ?? 0;
    debugPrint(
      '[motoristas] resposta ok: $totalFiliais filiais recebidas, $exibidas exibidas',
    );
    _dashboard.value = result.data;
    _publicarFiliaisAcesso();
  }

  /// As filiais do dashboard sao exatamente as que o motorista atende. Outros
  /// modulos (chamados) precisam dessa lista para saber onde ele pode atuar,
  /// ja que a filial de lotacao dele nao representa isso.
  ///
  /// Publica a lista completa de proposito: uma filial sem medicao nem
  /// carregamento hoje nao aparece no card, mas continua sendo um lugar valido
  /// para abrir um chamado.
  void _publicarFiliaisAcesso() {
    final todasFiliais =
        _dashboard.value?.filiais ?? const <FilialMotoristaModel>[];
    Get.find<FiliaisAcessoService>().publicar(
      todasFiliais
          .map((f) => FilialAcessoModel(id: f.id, nome: f.nome))
          .toList(),
    );
  }
}
