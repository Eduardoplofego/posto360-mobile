import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:posto360/core/constants/constants.dart';
import 'package:posto360/core/mixins/loader_mixin.dart';
import 'package:posto360/models/horario_faltas_model.dart';
import 'package:posto360/models/user_model.dart';
import 'package:posto360/services/horario_faltas_atrasos/horario_faltas_atrasos_service.dart';

class DashController extends GetxController with LoaderMixin {
  late HorarioFaltasAtrasosService _horarioFaltasAtrasosService;

  final _loader = false.obs;

  DashController() {
    _horarioFaltasAtrasosService = Get.find<HorarioFaltasAtrasosService>();
  }

  @override
  void onInit() {
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

  UserModel get autheticatedUser => _authenticatedUser.value;
  String get nameUser =>
      autheticatedUser.name + (autheticatedUser.lastName ?? '');
  bool get hasPhotoUrl =>
      autheticatedUser.photoUrl != null && autheticatedUser.photoUrl != '';
  HorarioFaltasModel get horarioFaltasAtrasos => _horarioFaltasAtrasos.value;

  Future<void> _initVariables() async {
    _loader(true);
    _authenticatedUser.value = UserModel.fromMap(
      GetStorage().read(Constants.USER_KEY),
    );
    _horarioFaltasAtrasos.value = await _horarioFaltasAtrasosService.getHorario(
      data: '2025-03-12',
      codigoFuncionario: autheticatedUser.codigoPDV.toString(),
    );
    _loader(false);
  }
}
