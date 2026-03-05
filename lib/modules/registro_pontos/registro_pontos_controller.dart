import 'package:get/get.dart';
import 'package:posto360/modules/core/domain/mixins/message_mixin.dart';
import 'package:posto360/modules/core/domain/services/auth_service.dart';
import 'package:posto360/modules/registro_pontos/domain/adapters/month_adapter.dart';
import 'package:posto360/modules/registro_pontos/domain/models/faltas_atrasos_model.dart';
import 'package:posto360/modules/registro_pontos/domain/models/pontos_model.dart';
import 'package:posto360/modules/registro_pontos/infra/services/registro_pontos_services.dart';

class RegistroPontosController extends GetxController with MessageMixin {
  final RegistroPontosServices _registroPontosServices;
  final AuthService _authService;

  RegistroPontosController(this._registroPontosServices, this._authService);

  @override
  void onInit() {
    messageListener(_message);
    super.onInit();
    _selectMonthByParameter();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await _loadData();
  }

  // Observables
  final _loadingData = false.obs;
  final _monthSelected = DateTime.now().obs;
  final _registroPontoModel = Rx(FaltasAtrasosModel.empty());
  final _pontosList = <PontosModel>[].obs;

  final _message = Rxn<MessagesModel>();

  // Getters
  bool get loadingData => _loadingData.value;
  DateTime get monthSelected => _monthSelected.value;
  FaltasAtrasosModel get registroPontoModel => _registroPontoModel.value;
  String get monthSelectedText =>
      '${getMonthText(monthSelected.month)} ${monthSelected.year}';
  List<PontosModel> get pontosList => _pontosList;
  bool get hasNextMonth =>
      !(monthSelected.month == DateTime.now().month &&
          monthSelected.year == DateTime.now().year);

  // Actions
  void _selectMonthByParameter() {
    String? monthArgument = Get.parameters['month'];
    if (monthArgument == null) {
      _monthSelected(DateTime.now());
      return;
    }
    final monthFormated = DateTime.parse(monthArgument);
    _monthSelected(monthFormated);
  }

  void prevMonth(DateTime monthSelected) {
    _monthSelected.value = monthSelected;
    _loadData();
  }

  void nextMonth(DateTime monthSelected) async {
    _monthSelected.value = monthSelected;
    _loadData();
  }

  Future<void> _loadData() async {
    _loadingData.value = true;
    await _loadPontos();
    await _loadFaltasAtrasos();
    _loadingData.value = false;
  }

  Future<void> _loadPontos() async {
    final results = await _registroPontosServices.getAllRegisters(
      usuarioId: _authService.authenticatedUser!.id,
      monthSelected: monthSelected,
    );
    if (results.isError) {
      _message(
        MessagesModel(
          title: 'Erro',
          message: results.message,
          type: MessageType.error,
        ),
      );
      return;
    }

    _pontosList.assignAll(results.data!.reversed);
  }

  Future<void> _loadFaltasAtrasos() async {
    final results = await _registroPontosServices.getFaltasAtrasos(
      codigoFuncionario: _authService.authenticatedUser!.codigoPDV!,
      monthSelected: monthSelected,
    );
    if (results.isError) {
      _message(
        MessagesModel(
          title: 'Erro',
          message: results.message,
          type: MessageType.error,
        ),
      );
      return;
    }
    _registroPontoModel(results.data);
  }
}
