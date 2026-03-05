import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:posto360/modules/campanhas/domain/models/performance_individual_model.dart';
import 'package:posto360/modules/core/domain/constants/constants.dart';
import 'package:posto360/modules/core/domain/mixins/loader_mixin.dart';
import 'package:posto360/modules/core/domain/mixins/message_mixin.dart';
import 'package:posto360/modules/core/domain/services/auth_service.dart';
import 'package:posto360/modules/core/domain/utils/data_formatters.dart';
import 'package:posto360/modules/campanhas/domain/models/campanha_model.dart';
import 'package:posto360/modules/campanhas/domain/models/performance_equipe_model.dart';
import 'package:posto360/modules/campanhas/domain/models/campanha_controller_model.dart';
import 'package:posto360/modules/campanhas/infra/services/app_campanhas_service.dart';
import 'package:posto360/modules/campanhas/infra/services/performance_service.dart';

class CampanhasController extends FullLifeCycleController
    with MessageMixin, LoaderMixin, FullLifeCycleMixin {
  final AppCampanhasService _campanhasService;
  final PerformanceService _performanceService;
  final AuthService _authService;

  CampanhasController({
    required AppCampanhasService campanhaService,
    required AuthService authService,
    required PerformanceService performanceService,
  }) : _campanhasService = campanhaService,
       _authService = authService,
       _performanceService = performanceService;

  // Observables
  final _message = Rxn<MessagesModel>();
  final _loader = false.obs;
  final _campanhaController = Rx<CampanhaControllerModel>(
    CampanhaControllerModel.empty(),
  );
  final _monthSelected = DateTime.now().obs;
  final _currentMonth = DateTime.now().obs;

  final List<PerformanceIndividualModel> _individualPerformances = [];
  final List<PerformanceEquipeModel> _equipePerformances = [];

  // Getters
  CampanhaControllerModel get campanhaController => _campanhaController.value;
  List<CampanhaModel> get campanhas => campanhaController.campanhas;
  List<PerformanceIndividualModel> get individualPerformances =>
      _individualPerformances;
  List<PerformanceEquipeModel> get equipePerformances => _equipePerformances;
  bool get isLoading => _loader.value;
  DateTime get monthSelected => _monthSelected.value;
  DateTime get currentMonth => _currentMonth.value;
  bool get hasNextMonth =>
      !(monthSelected.month == DateTime.now().month &&
          monthSelected.year == DateTime.now().year);
  List<DateTime> get periodSelected => campanhaController.getPeriodSelected();
  double get valueTotalBonus {
    double total = 0.0;
    for (var campanha in campanhas) {
      final totalMetaIndividual = campanha.bonificacaoIndividualConquistada;
      final totalMetaEquipe = campanha.bonificacaoEquipeConquistada;
      total += totalMetaIndividual + totalMetaEquipe;
    }
    return total;
  }

  // Actions
  @override
  void onInit() {
    messageListener(_message);
    loaderListener(_loader);
    _selectMonthByParameter();
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    _loadVariables();
  }

  void _selectMonthByParameter() {
    String? monthArgument = Get.parameters['month'];
    if (monthArgument == null) {
      _monthSelected(DateTime.now());
      return;
    }
    final monthFormated = DateTime.parse(monthArgument);
    _monthSelected(monthFormated);
  }

  Future<void> _loadVariables() async {
    _loader(true);
    await _loadCampanhas();
    await _loadPerformances();
    campanhaController.calculateValueTotalBonus();
    _loader(false);
  }

  Future<void> onRefresh() async {
    await GetStorage().write(Constants.CAMPANHAS_CONTROLLER, null);
    _loadVariables();
  }

  Future<void> _loadCampanhas() async {
    final campanhas = await _campanhasService.getAllCampanhas(
      filialId: _authService.authenticatedUser!.idFilial!,
      usuarioId: _authService.authenticatedUser!.id,
      empresaId: _authService.authenticatedUser!.idEmpresa,
      data: _monthSelected.value,
    );
    if (campanhas.isError) {
      _message(
        MessagesModel(
          title: 'Erro',
          message: campanhas.message,
          type: MessageType.error,
        ),
      );
    } else {
      campanhaController.campanhas.assignAll(campanhas.data!);
    }
  }

  Future<void> _loadPerformances() async {
    var campanhasIds = <int>[];

    if (campanhas.isEmpty) {
      return;
    }

    campanhasIds =
        campanhas.map<int>((campanha) => campanha.campanhaId).toList();

    final individualPerformances = await _performanceService
        .getIndividualPerformances(
          codigoFuncionario: _authService.authenticatedUser!.codigoPDV!,
          campanhasId: campanhasIds,
          dataMes: DataFormatters.formatarData(monthSelected),
        );

    if (individualPerformances.isError) {
      _message(
        MessagesModel(
          title: 'Erro',
          message: individualPerformances.message,
          type: MessageType.error,
        ),
      );
    }

    _individualPerformances.assignAll(individualPerformances.data!);

    final equipePerformances = await _performanceService.getEquipePerformances(
      filialId: _authService.authenticatedUser!.idFilial!,
      campanhasId: campanhasIds,
      data: DataFormatters.formatarData(monthSelected),
    );

    if (individualPerformances.isError) {
      _message(
        MessagesModel(
          title: 'Erro',
          message: equipePerformances.message,
          type: MessageType.error,
        ),
      );
    }

    _equipePerformances.assignAll(equipePerformances.data!);
  }

  PerformanceIndividualModel getPerformanceIndividualByCampanhaId(
    int campanhaId,
  ) {
    return individualPerformances.firstWhere(
      (performance) => performance.campanhaId == campanhaId,
      orElse: () => PerformanceIndividualModel.empty(),
    );
  }

  PerformanceEquipeModel getPerformanceEquipeByCampanhaId(int campanhaId) {
    return equipePerformances.firstWhere(
      (performance) => performance.campanhaId == campanhaId,
      orElse: () => PerformanceEquipeModel.empty(),
    );
  }

  void _defineNewPeriodSelected(DateTime dateSelected) {
    final today = DateTime.now();
    if (dateSelected.year == today.year && dateSelected.month == today.month) {
      _campanhaController.value.firstDateSelected = DateTime(
        DateTime.now().year,
        DateTime.now().month,
        1,
      );
      _campanhaController.value.lastDateSelected = DateTime.now();
    } else {
      final firstDay = DateTime(
        dateSelected.year,
        dateSelected.month,
        dateSelected.day,
      );
      final lastDay = DateTime(
        dateSelected.year,
        dateSelected.month + 1,
        dateSelected.day,
      ).subtract(const Duration(days: 1));
      _campanhaController.value.firstDateSelected = firstDay;
      _campanhaController.value.lastDateSelected = lastDay;
    }
  }

  void prevMonth(DateTime monthSelected) {
    campanhaController.resetController();
    _monthSelected.value = monthSelected;
    _defineNewPeriodSelected(monthSelected);
    _loadVariables();
  }

  void nextMonth(DateTime monthSelected) async {
    campanhaController.resetController();
    _monthSelected.value = monthSelected;
    _defineNewPeriodSelected(monthSelected);
    _loadVariables();
  }

  @override
  void onDetached() {
    GetStorage().write(Constants.CAMPANHAS_CONTROLLER, null);
  }

  @override
  void onHidden() {}

  @override
  void onInactive() {}

  @override
  void onPaused() {}

  @override
  void onResumed() {}
}
