import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:posto360/modules/core/domain/constants/constants.dart';
import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/core/domain/mixins/message_mixin.dart';
import 'package:posto360/modules/core/domain/services/auth_service.dart';
import 'package:posto360/modules/core/domain/services/notification_service.dart';
import 'package:posto360/modules/core/domain/utils/data_formatters.dart';
import 'package:posto360/modules/dash/domain/models/dashboard_model.dart';
import 'package:posto360/modules/dash/domain/models/horario_faltas_model.dart';
import 'package:posto360/modules/core/domain/models/user_model.dart';
import 'package:posto360/modules/campanhas/infra/services/campanhas_service.dart';
import 'package:posto360/modules/dash/infra/services/dashboard_service.dart';
import 'package:posto360/modules/dash/infra/services/horario_faltas_atrasos_service.dart';
import 'package:posto360/modules/core/infra/services/user_service.dart';

class DashController extends FullLifeCycleController
    with MessageMixin, FullLifeCycleMixin {
  late CampanhasService _campanhasService;
  late HorarioFaltasAtrasosService _horarioFaltasAtrasosService;
  late DashboardService _dashboardService;
  late NotificationService _notificationService;
  late UserService _userService;

  final _loader = false.obs;
  final _message = Rxn<MessagesModel>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _selectPeriodScrollController = ScrollController();

  DashController() {
    _campanhasService = Get.find<CampanhasService>();
    _horarioFaltasAtrasosService = Get.find<HorarioFaltasAtrasosService>();
    _notificationService = Get.find<NotificationService>();
    _dashboardService = Get.find<DashboardService>();
    _userService = Get.find<UserService>();
  }

  @override
  void onInit() {
    messageListener(_message);
    super.onInit();
  }

  @override
  void onReady() async {
    GetStorage().write(Constants.CAMPANHAS_CONTROLLER, null);
    await _initVariables();
    super.onReady();
  }

  // loadings
  final _loadingDashboardModel = false.obs;
  final _loadingWork = false.obs;
  bool get loadingDashboardModel => _loadingDashboardModel.value;
  bool get loadingWork => _loadingWork.value;

  final _dashboardModel = Rx(DashboardModel.empty());
  final _hasDashboardModel = false.obs;
  final _authenticatedUser = Rx<UserModel>(UserModel.empty());
  final _horarioFaltasAtrasos = Rx<HorarioFaltasModel>(
    HorarioFaltasModel.empty(),
  );
  final _hasData = false.obs;
  final _daysRegistered = 0.obs;
  final _monthSelected = DateTime.now().obs;
  final _hasNextMonth = false.obs;

  DashboardModel get dashboardModel => _dashboardModel.value;
  bool get hasDashboardModel => _hasDashboardModel.value;
  UserModel get autheticatedUser => _authenticatedUser.value;
  String get nameUser =>
      autheticatedUser.name + (autheticatedUser.lastName ?? '');
  bool get hasPhotoUrl =>
      GetStorage().read(Constants.USER_PHOTO_URL) != null ||
      autheticatedUser.photoUrl != null && autheticatedUser.photoUrl != '';
  bool get hasNotification => _notificationService.hasNotification;
  HorarioFaltasModel get horarioFaltasAtrasos => _horarioFaltasAtrasos.value;
  bool get hasData => _hasData.value;
  DateTime get monthSelected => _monthSelected.value;
  bool get hasNextMonth => _hasNextMonth.value;
  bool get isLoading => _loader.value;
  int get daysRegistered => _daysRegistered.value;
  ScrollController get selectPeriodScrollController =>
      _selectPeriodScrollController;
  String get photoUrl {
    final isToTakeFomrStorage =
        GetStorage().read(Constants.USER_PHOTO_URL) != null;
    if (isToTakeFomrStorage) {
      return GetStorage().read(Constants.USER_PHOTO_URL);
    } else {
      return autheticatedUser.photoUrl ?? '';
    }
  }

  Future<void> onRefresh() async {
    await _initVariables();
  }

  Future<void> _initVariables() async {
    _authenticatedUser.value = UserModel.fromMap(
      GetStorage().read(Constants.USER_KEY),
    );
    _loadQuantityDaysInMonth();
    _loader(true);
    await Future.wait([_loadHorarioFaltaAtraso(), loadDashboardModel()]);
    _loader(false);
  }

  void _loadQuantityDaysInMonth() {
    final today = DateTime.now();
    if (monthSelected.year == today.year &&
        monthSelected.month == today.month) {
      _daysRegistered.value = today.day;
    } else {
      _daysRegistered.value =
          DateTime(monthSelected.year, monthSelected.month + 1, 0).day;
    }
  }

  Future<void> loadDashboardModel() async {
    _loadingDashboardModel(true);
    final resultCampanhas = await _campanhasService.getAllCampanhas(
      filialId: autheticatedUser.idFilial!,
      tipoUsuario: autheticatedUser.tipoUsuario,
      data: monthSelected,
    );

    if (resultCampanhas.success || resultCampanhas.data!.isNotEmpty) {
      final dashboardResult = await _dashboardService.getDashboardData(
        funcionarioCodigo: autheticatedUser.codigoPDV!,
        campanhas: resultCampanhas.data!,
        data: DataFormatters.formatarData(monthSelected),
      );

      if (dashboardResult.success) {
        _dashboardModel.value = dashboardResult.data!;
        _hasDashboardModel(true);
      } else {
        _hasDashboardModel(false);
      }
    } else {
      _hasDashboardModel(false);
    }

    _loadingDashboardModel(false);
  }

  Future<void> _loadHorarioFaltaAtraso() async {
    _loadingWork(true);
    final today = DateTime.now();
    final result = await _horarioFaltasAtrasosService.getHorario(
      data: today,
      codigoFuncionario: autheticatedUser.codigoPDV.toString(),
      dataMes: monthSelected,
    );

    if (result.isError) {
      _loadingWork(false);
      _horarioFaltasAtrasos.value = HorarioFaltasModel.empty();
      _message(
        MessagesModel(
          title: 'Erro',
          message: 'Erro ao buscar dados',
          type: MessageType.error,
        ),
      );
      _hasData(false);
    } else {
      if (result.success && result.message.isNotEmpty) {
        _horarioFaltasAtrasos.value = HorarioFaltasModel.empty();
        _message(
          MessagesModel(
            title: 'Erro',
            message: 'Não foi possível buscar os horários na data selecionada',
            type: MessageType.info,
          ),
        );
        _hasData(false);
      }
      _horarioFaltasAtrasos.value = result.data!;
      _hasData(true);
    }
    _loadingWork(false);
  }

  Future<void> prevMonth(DateTime monthSelected) async {
    _monthSelected.value = monthSelected;
    _hasNextMonth.value = true;
    _loadingDashboardModel(true);
    await _loadHorarioFaltaAtraso();
    _loadQuantityDaysInMonth();
    await loadDashboardModel();
  }

  Future<void> nextMonth(DateTime monthSelected) async {
    final now = DateTime.now();

    _hasNextMonth.value =
        !(monthSelected.year == now.year && monthSelected.month == now.month);

    _monthSelected.value = monthSelected;
    _loadingDashboardModel(true);
    await _loadHorarioFaltaAtraso();
    _loadQuantityDaysInMonth();
    await loadDashboardModel();
  }

  Future<ResultActionDTO<String>> onSavePhoto(String imagePath) async {
    final result = await _userService.sendProfilePhoto(
      userId: Get.find<AuthService>().getUser()!.id,
      imagePath: imagePath,
    );

    return result;
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
