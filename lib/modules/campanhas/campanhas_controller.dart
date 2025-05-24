import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:posto360/core/constants/constants.dart';
import 'package:posto360/core/mixins/message_mixin.dart';
import 'package:posto360/core/services/auth_service.dart';
import 'package:posto360/models/campanha_model.dart';
import 'package:posto360/models/performance_model.dart';
import 'package:posto360/modules/campanhas/models/campanha_controller_model.dart';
import 'package:posto360/modules/campanhas/widgets/campanha_card_widget.dart';
import 'package:posto360/services/campanhas/campanhas_service.dart';
import 'package:posto360/services/performance/performance_service.dart';

class CampanhasController extends FullLifeCycleController
    with MessageMixin, FullLifeCycleMixin {
  final CampanhasService _campanhasService;
  final PerformanceService _performanceService;
  final AuthService _authService;

  CampanhasController({
    required CampanhasService campanhaService,
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
  final _hasNextMonth = false.obs;

  // Getters
  CampanhaControllerModel get campanhaController => _campanhaController.value;
  List<CampanhaModel> get campanhas => campanhaController.campanhas;
  List<PerformanceModel> get performances => campanhaController.performances;
  bool get isLoading => _loader.value;
  double get valueTotalBonus => campanhaController.totalValueBonus;
  DateTime get monthSelected => _monthSelected.value;
  DateTime get currentMonth => _currentMonth.value;
  bool get hasNextMonth => _hasNextMonth.value;
  List<DateTime> get periodSelected => campanhaController.getPeriodSelected();
  Map<int, dynamic> get performancesListMap =>
      campanhaController.getPerformanceMap();

  // Actions
  @override
  void onInit() {
    messageListener(_message);
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    _loadVariables();
  }

  Future<void> _loadVariables() async {
    _loader(true);
    final isLoadInStorage = _checkIfHadToTakeOnStorage();
    if (isLoadInStorage) {
      _loadController();
    } else {
      await _loadCampanhas();
      await _loadPerformances();
    }
    campanhaController.calculateValueTotalBonus();
    _loader(false);
  }

  void _loadController() {
    final controllerMap = GetStorage().read(Constants.CAMPANHAS_CONTROLLER);
    _campanhaController.value = CampanhaControllerModel.fromMap(controllerMap);
    _monthSelected.value = campanhaController.firstDateSelected;
    _hasNextMonth.value =
        campanhaController.firstDateSelected.month != currentMonth.month &&
        (campanhaController.firstDateSelected.year == currentMonth.year ||
            campanhaController.firstDateSelected.year != currentMonth.year);
  }

  bool _checkIfHadToTakeOnStorage() {
    if (GetStorage().read(Constants.CAMPANHAS_CONTROLLER) != null) {
      return true;
    }
    return false;
  }

  Future<void> onRefresh() async {
    await GetStorage().write(Constants.CAMPANHAS_CONTROLLER, null);
    _loadVariables();
  }

  Future<void> _loadCampanhas() async {
    _loader(true);
    final campanhas = await _campanhasService.getAllCampanhas(
      filialId: _authService.authenticatedUser!.idFilial!,
      tipoUsuario: _authService.authenticatedUser!.tipoUsuario,
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
      campanhaController.campanhas = campanhas.data!;
    }
    _loader(false);
  }

  Future<void> _loadPerformances() async {
    var campanhasIds = <int>[];

    if (campanhas.isNotEmpty) {
      campanhasIds =
          campanhas.map<int>((campanha) => campanha.campanhaId).toList();
    }

    final performances = await _performanceService.getPerformances(
      codigoFuncionario: _authService.authenticatedUser!.codigoPDV.toString(),
      campanhasId: campanhasIds,
      dataMes: monthSelected,
    );
    if (performances.isError) {
      _message(
        MessagesModel(
          title: 'Erro',
          message: performances.message,
          type: MessageType.error,
        ),
      );
    } else {
      campanhaController.performances = performances.data!;
    }
  }

  List<CampanhaCardWidget> loadCampanhaCards() {
    if (campanhas.isEmpty) return [];
    return campanhas.map((campanha) {
      return CampanhaCardWidget(
        campanha: campanha,
        performace:
            performancesListMap[campanha.campanhaId] ??
            PerformanceModel.empty(),
      );
    }).toList();
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
    _monthSelected.value = monthSelected;
    _hasNextMonth.value = true;
    _defineNewPeriodSelected(monthSelected);
    _loadCampanhas();
    _loadPerformances();
  }

  void nextMonth(DateTime monthSelected) async {
    final now = DateTime.now();

    _hasNextMonth.value =
        !(monthSelected.year == now.year && monthSelected.month == now.month);

    _monthSelected.value = monthSelected;
    _defineNewPeriodSelected(monthSelected);
    _loadCampanhas();
    _loadPerformances();
  }

  Future<void> saveControllerOnBackground() async {
    final getStorage = GetStorage();
    final mapToSave = campanhaController.toMap();
    getStorage.write(Constants.CAMPANHAS_CONTROLLER, mapToSave);
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
