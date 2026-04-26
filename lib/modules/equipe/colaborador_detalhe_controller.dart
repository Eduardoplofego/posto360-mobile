import 'package:get/get.dart';
import 'package:posto360/modules/core/domain/models/user_model.dart';
import 'package:posto360/modules/dash/domain/models/cartoes_model.dart';
import 'package:posto360/modules/dash/domain/models/dashboard_model.dart';
import 'package:posto360/modules/dash/domain/models/horario_faltas_model.dart';
import 'package:posto360/modules/dash/infra/services/fechamento_caixa_service.dart';
import 'package:posto360/modules/dash/infra/services/horario_faltas_atrasos_service.dart';
import 'package:posto360/modules/equipe/infra/services/equipe_service.dart';

class ColaboradorDetalheController extends GetxController {
  final EquipeService _equipeService;
  final HorarioFaltasAtrasosService _horarioService;
  final FechamentoCaixaService _fechamentoService;

  ColaboradorDetalheController({
    required EquipeService equipeService,
    required HorarioFaltasAtrasosService horarioService,
    required FechamentoCaixaService fechamentoService,
  })  : _equipeService = equipeService,
        _horarioService = horarioService,
        _fechamentoService = fechamentoService;

  final _loadingUser = false.obs;
  final _loadingCampanhas = false.obs;
  final _loadingCursos = false.obs;
  final _loadingChecklists = false.obs;
  final _loadingHorario = false.obs;
  final _loadingCartoes = false.obs;

  final _user = Rxn<UserModel>();
  final _dashboardModel = Rx(DashboardModel.empty());
  final _horario = Rx(HorarioFaltasModel.empty());
  final _cartoes = Rx(CartoesModel.empty());
  final _userError = ''.obs;

  bool get loadingUser => _loadingUser.value;
  bool get loadingCampanhas => _loadingCampanhas.value;
  bool get loadingCursos => _loadingCursos.value;
  bool get loadingChecklists => _loadingChecklists.value;
  bool get loadingHorario => _loadingHorario.value;
  bool get loadingCartoes => _loadingCartoes.value;

  UserModel? get user => _user.value;
  DashboardModel get dashboardModel => _dashboardModel.value;
  HorarioFaltasModel get horario => _horario.value;
  CartoesModel get cartoes => _cartoes.value;
  String get userError => _userError.value;
  bool get hasUserError => _userError.value.isNotEmpty;

  String? get colaboradorId => Get.parameters['id'];
  DateTime get monthSelected => DateTime.now();

  double get penalidadeTotal =>
      dashboardModel.penalidadeChecklists +
      dashboardModel.penalidadeCursos +
      horario.penalidade.toDouble() +
      cartoes.penalidade;

  @override
  Future<void> onReady() async {
    super.onReady();
    await onRefresh();
  }

  Future<void> onRefresh() async {
    final id = colaboradorId;
    if (id == null) {
      _userError.value = 'Colaborador inválido.';
      return;
    }
    _userError.value = '';
    await _loadUser(id);
    final user = _user.value;
    if (user == null) return;
    await Future.wait([
      _loadCampanhas(user),
      _loadHorario(user),
      _loadCartoes(user),
      _loadCursos(user),
      _loadChecklists(user),
    ]);
  }

  Future<void> _loadUser(String id) async {
    _loadingUser.value = true;
    final result = await _equipeService.getColaborador(id: id);
    if (result.success && result.data != null) {
      _user.value = result.data;
    } else {
      _user.value = null;
      _userError.value = result.message;
    }
    _loadingUser.value = false;
  }

  Future<void> _loadCampanhas(UserModel user) async {
    _loadingCampanhas.value = true;
    final funcionarioCodigo = user.codigoPDV;
    if (funcionarioCodigo == null) {
      _loadingCampanhas.value = false;
      return;
    }
    final result = await _equipeService.getCampanhasResumo(
      funcionarioCodigo: funcionarioCodigo,
      idsCampanhas: user.campanhasIds,
      dataAtual: monthSelected,
    );
    if (result.success && result.data != null) {
      _dashboardModel.value.campanhasAtivas = result.data!.campanhasAtivas;
      _dashboardModel.value.bonificacaoTotal = result.data!.bonificacaoTotal;
      _dashboardModel.refresh();
    }
    _loadingCampanhas.value = false;
  }

  Future<void> _loadCursos(UserModel user) async {
    _loadingCursos.value = true;
    final funcionarioCodigo = user.codigoPDV;
    if (funcionarioCodigo == null) {
      _loadingCursos.value = false;
      return;
    }
    final result = await _equipeService.getCursosResumo(
      funcionarioCodigo: funcionarioCodigo,
      dataAtual: monthSelected,
    );
    if (result.success && result.data != null) {
      _dashboardModel.value.totalCursos = result.data!.total;
      _dashboardModel.value.cursosConcluidos = result.data!.concluidos;
      _dashboardModel.value.penalidadeCursos = result.data!.penalidades;
      _dashboardModel.refresh();
    }
    _loadingCursos.value = false;
  }

  Future<void> _loadChecklists(UserModel user) async {
    _loadingChecklists.value = true;
    final funcionarioCodigo = user.codigoPDV;
    if (funcionarioCodigo == null) {
      _loadingChecklists.value = false;
      return;
    }
    final result = await _equipeService.getChecklistsResumo(
      funcionarioCodigo: funcionarioCodigo,
      dataAtual: monthSelected,
    );
    if (result.success && result.data != null) {
      _dashboardModel.value.totalChecklist = result.data!.total;
      _dashboardModel.value.checklistsConcluidas = result.data!.concluidos;
      _dashboardModel.value.penalidadeChecklists = result.data!.penalidades;
      _dashboardModel.refresh();
    }
    _loadingChecklists.value = false;
  }

  Future<void> _loadHorario(UserModel user) async {
    _loadingHorario.value = true;
    final funcionarioCodigo = user.codigoPDV;
    if (funcionarioCodigo == null) {
      _horario.value = HorarioFaltasModel.empty();
      _loadingHorario.value = false;
      return;
    }
    final result = await _horarioService.getHorario(
      dataAtual: DateTime.now(),
      dataSelecionada: monthSelected,
      funcionarioCodigo: funcionarioCodigo,
    );
    if (result.success && result.data != null) {
      _horario.value = result.data!;
    } else {
      _horario.value = HorarioFaltasModel.empty();
    }
    _loadingHorario.value = false;
  }

  Future<void> _loadCartoes(UserModel user) async {
    _loadingCartoes.value = true;
    final result = await _fechamentoService.getFechamento(
      usuarioId: user.id,
      dataMes: monthSelected,
    );
    if (result.success && result.data != null) {
      _cartoes.value = result.data!;
    } else {
      _cartoes.value = CartoesModel.empty();
    }
    _loadingCartoes.value = false;
  }
}
