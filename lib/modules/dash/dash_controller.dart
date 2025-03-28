import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:posto360/core/constants/constants.dart';
import 'package:posto360/core/mixins/message_mixin.dart';
import 'package:posto360/core/services/notification_service.dart';
import 'package:posto360/models/horario_faltas_model.dart';
import 'package:posto360/models/user_model.dart';
import 'package:posto360/services/horario_faltas_atrasos/horario_faltas_atrasos_service.dart';

class DashController extends FullLifeCycleController
    with MessageMixin, FullLifeCycleMixin {
  late HorarioFaltasAtrasosService _horarioFaltasAtrasosService;
  late NotificationService _notificationService;

  final _loader = false.obs;
  final _message = Rxn<MessagesModel>();
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _selectPeriodScrollController = ScrollController();

  DashController() {
    _horarioFaltasAtrasosService = Get.find<HorarioFaltasAtrasosService>();
    _notificationService = Get.find<NotificationService>();
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

  final _authenticatedUser = Rx<UserModel>(UserModel.empty());
  final _horarioFaltasAtrasos = Rx<HorarioFaltasModel>(
    HorarioFaltasModel.empty(),
  );
  final _hasData = false.obs;
  final _daysRegistered = 0.obs;

  UserModel get autheticatedUser => _authenticatedUser.value;
  String get nameUser =>
      autheticatedUser.name + (autheticatedUser.lastName ?? '');
  bool get hasPhotoUrl =>
      autheticatedUser.photoUrl != null && autheticatedUser.photoUrl != '';
  bool get hasNotification => _notificationService.hasNotification;
  HorarioFaltasModel get horarioFaltasAtrasos => _horarioFaltasAtrasos.value;
  bool get hasData => _hasData.value;
  bool get isLoading => _loader.value;
  int get daysRegistered => _daysRegistered.value;
  ScrollController get selectPeriodScrollController =>
      _selectPeriodScrollController;

  Future<void> onRefresh() async {
    await _initVariables();
  }

  Future<void> _initVariables() async {
    _loader(true);
    _authenticatedUser.value = UserModel.fromMap(
      GetStorage().read(Constants.USER_KEY),
    );
    await _loadHorarioFaltaAtraso();
    _daysRegistered.value = 18;
    _loader(false);
  }

  Future<void> _loadHorarioFaltaAtraso() async {
    final today = DateTime.now();
    final result = await _horarioFaltasAtrasosService.getHorario(
      data: today,
      codigoFuncionario: autheticatedUser.codigoPDV.toString(),
    );

    if (result.isError) {
      _loader(false);
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
      _loader(false);
      _hasData(true);
    }

    if (result.success && result.message.isNotEmpty) {
      _message(
        MessagesModel(
          title: 'Erro',
          message: 'Não foi possível buscar os dados de hoje',
          type: MessageType.info,
        ),
      );
      _hasData(false);
    }
    _horarioFaltasAtrasos.value = result.data!;
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
