import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:posto360/core/constants/constants.dart';
import 'package:posto360/core/mixins/message_mixin.dart';
import 'package:posto360/core/services/auth_service.dart';
import 'package:posto360/core/services/notification_service.dart';
import 'package:posto360/core/utils/enums/curso_status.dart';
import 'package:posto360/models/curso_model.dart';
import 'package:posto360/models/horario_faltas_model.dart';
import 'package:posto360/models/user_model.dart';
import 'package:posto360/services/cursos/cursos_service.dart';
import 'package:posto360/services/horario_faltas_atrasos/horario_faltas_atrasos_service.dart';

class DashController extends FullLifeCycleController
    with MessageMixin, FullLifeCycleMixin {
  late HorarioFaltasAtrasosService _horarioFaltasAtrasosService;
  late NotificationService _notificationService;
  late CursosService _cursosService;

  final _loader = false.obs;
  final _message = Rxn<MessagesModel>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _selectPeriodScrollController = ScrollController();

  DashController() {
    _horarioFaltasAtrasosService = Get.find<HorarioFaltasAtrasosService>();
    _notificationService = Get.find<NotificationService>();
    _cursosService = Get.find<CursosService>();
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
  final _loadingWork = false.obs;
  final _loadingPerformance = false.obs;
  final _loadingCursos = false.obs;
  final _loadingCheckList = false.obs;
  bool get loadingWork => _loadingWork.value;
  bool get loadingPerformance => _loadingPerformance.value;
  bool get loadingCursos => _loadingCursos.value;
  bool get loadingCheckList => _loadingCheckList.value;

  final _cursosList = <CursoModel>[].obs;
  final _totalCursos = 0.obs;
  final _totalCursosConcluidos = 0.obs;
  final _authenticatedUser = Rx<UserModel>(UserModel.empty());
  final _horarioFaltasAtrasos = Rx<HorarioFaltasModel>(
    HorarioFaltasModel.empty(),
  );
  final _hasData = false.obs;
  final _daysRegistered = 0.obs;
  final _monthSelected = DateTime.now().obs;
  final _hasNextMonth = false.obs;

  List<CursoModel> get cursos => _cursosList;
  int get totalCursos => _totalCursos.value;
  int get totalCursosConcluidos => _totalCursosConcluidos.value;
  UserModel get autheticatedUser => _authenticatedUser.value;
  String get nameUser =>
      autheticatedUser.name + (autheticatedUser.lastName ?? '');
  bool get hasPhotoUrl =>
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

  Future<void> onRefresh() async {
    await _initVariables();
  }

  Future<void> _initVariables() async {
    _authenticatedUser.value = UserModel.fromMap(
      GetStorage().read(Constants.USER_KEY),
    );
    await Future.wait([_loadHorarioFaltaAtraso(), _loadCursos()]);
    _loadQuantityDaysInMonth();
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

  Future<void> _loadCursos() async {
    _loadingCursos(true);
    final result = await _cursosService.getAllCursos(
      usuarioId: Get.find<AuthService>().getUser()!.id,
    );
    final cursos = result.data!;
    var totalCursos = 0;
    var totalConcluidos = 0;
    for (var curso in cursos) {
      if (curso.status == CursoStatus.finalizado) {
        totalConcluidos += 1;
      }
      totalCursos += 1;
      _cursosList.add(curso);
    }
    _totalCursos.value = totalCursos;
    _totalCursosConcluidos.value = totalConcluidos;
    _cursosList.assignAll(cursos);
    _loadingCursos(false);
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
            message: 'Não foi possível buscar os horários de hoje',
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
    await _loadHorarioFaltaAtraso();
    _loadQuantityDaysInMonth();
  }

  Future<void> nextMonth(DateTime monthSelected) async {
    final now = DateTime.now();

    _hasNextMonth.value =
        !(monthSelected.year == now.year && monthSelected.month == now.month);

    _monthSelected.value = monthSelected;
    await _loadHorarioFaltaAtraso();
    _loadQuantityDaysInMonth();
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
