import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:posto360/core/constants/constants.dart';
import 'package:posto360/core/mixins/loader_mixin.dart';
import 'package:posto360/core/mixins/message_mixin.dart';
import 'package:posto360/models/horario_faltas_model.dart';
import 'package:posto360/models/user_model.dart';
import 'package:posto360/services/horario_faltas_atrasos/horario_faltas_atrasos_service.dart';

class DashController extends GetxController with MessageMixin, LoaderMixin {
  late HorarioFaltasAtrasosService _horarioFaltasAtrasosService;

  final _loader = false.obs;
  final _message = Rxn<MessagesModel>();

  DashController() {
    _horarioFaltasAtrasosService = Get.find<HorarioFaltasAtrasosService>();
  }

  @override
  void onInit() {
    messageListener(_message);
    loaderListener(_loader);
    super.onInit();
  }

  @override
  void onReady() async {
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
  HorarioFaltasModel get horarioFaltasAtrasos => _horarioFaltasAtrasos.value;
  bool get hasData => _hasData.value;
  bool get isLoading => _loader.value;
  int get daysRegistered => _daysRegistered.value;

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
    final result = await _horarioFaltasAtrasosService.getHorario(
      data: '2025-03-12',
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
    } else {
      _loader(false);
      _hasData(true);
    }
    _horarioFaltasAtrasos.value = result.data!;
  }
}
