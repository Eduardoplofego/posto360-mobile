import 'package:get/get.dart';
import 'package:posto360/modules/registro_pontos/domain/adapters/month_adapter.dart';
import 'package:posto360/modules/registro_pontos/domain/models/pontos_model.dart';
import 'package:posto360/modules/registro_pontos/domain/models/registro_pontos_model.dart';

class RegistroPontosController extends GetxController {
  @override
  void onInit() {
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
  final _registroPontoModel = Rx(RegistroPontoModel.empty());
  final _pontosList = <PontosModel>[].obs;

  // Getters
  bool get loadingData => _loadingData.value;
  DateTime get monthSelected => _monthSelected.value;
  RegistroPontoModel get registroPontoModel => _registroPontoModel.value;
  String get monthSelectedText =>
      '${getMonthText(monthSelected.month)} ${monthSelected.year}';
  List<PontosModel> get pontosList => _pontosList;

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

  Future<void> _loadData() async {
    _loadingData.value = true;
    await _loadPontos();
    _loadingData.value = false;
  }

  Future<void> _loadPontos() async {
    await Future.delayed(Duration(seconds: 2));
    final pontos = [
      PontosModel(
        data: '2026-02-05',
        pontos: ['08:00', '11:00', '12:00', '21:00'],
      ),
      PontosModel(
        data: '2026-02-04',
        pontos: ['09:00', '12:00', '13:00', '18:00'],
      ),
      PontosModel(
        data: '2026-02-03',
        pontos: ['08:30', '11:30', '12:30', '19:00'],
      ),
      PontosModel(
        data: '2026-02-02',
        pontos: ['07:45', '10:45', '11:45', '17:30'],
      ),
      PontosModel(
        data: '2026-02-01',
        pontos: ['08:15', '12:15', '13:15', '20:00'],
      ),
    ];
    _pontosList.assignAll(pontos.reversed);
  }
}
