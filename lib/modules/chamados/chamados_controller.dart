import 'package:get/get.dart';
import 'package:posto360/modules/chamados/domain/models/chamado_model.dart';
import 'package:posto360/modules/chamados/infra/services/chamados_service.dart';
import 'package:posto360/modules/core/domain/models/user_model.dart';
import 'package:posto360/modules/core/domain/services/auth_service.dart';
import 'package:posto360/modules/core/domain/services/filiais_acesso_service.dart';

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
    if (user.isMotorista) {
      await _loadChamadosMotorista(user);
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

  /// O motorista abre chamado em qualquer filial que atende, mas e lotado em
  /// uma so. Filtrar pela filial de lotacao esconderia justamente os chamados
  /// que ele abriu na estrada, entao busca filial por filial e mantem apenas o
  /// que foi aberto por ele.
  Future<void> _loadChamadosMotorista(UserModel user) async {
    final filiais = Get.find<FiliaisAcessoService>().filiais;
    if (filiais.isEmpty) {
      _errorMessage.value = 'Nenhuma filial disponível para o motorista.';
      _chamados.clear();
      return;
    }
    final resultados = await Future.wait(
      filiais.map(
        (filial) => _chamadosService.getChamadosAbertos(
          filialId: filial.id,
          empresaId: user.idEmpresa,
        ),
      ),
    );
    // Uma filial fora do ar nao pode zerar a lista inteira; so falha quando
    // nenhuma respondeu.
    final falhas = resultados.where((r) => !r.success).toList();
    if (falhas.length == resultados.length) {
      _errorMessage.value = falhas.first.message;
      _chamados.clear();
      return;
    }
    final meusChamados = <ChamadoModel>[];
    for (final resultado in resultados) {
      for (final chamado in resultado.data ?? const <ChamadoModel>[]) {
        if (chamado.abertoPor?.id == user.id) meusChamados.add(chamado);
      }
    }
    meusChamados.sort((a, b) => b.id.compareTo(a.id));
    _chamados.assignAll(meusChamados);
  }
}
