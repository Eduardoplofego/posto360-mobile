import 'package:get/get.dart';
import 'package:posto360/modules/avaliacoes/domain/models/avaliacao_details_model.dart';
import 'package:posto360/modules/avaliacoes/infra/services/avaliacoes_module_service.dart';

class AvaliacoesCriteriosController extends GetxController {
  late AvaliacoesModuleService _avaliacoesService;

  AvaliacoesCriteriosController() {
    _avaliacoesService = Get.find<AvaliacoesModuleService>();
  }

  final _loading = false.obs;
  final _errorMessage = Rxn<String>();
  final _criterios = <AvaliacaoDetailsModel>[].obs;
  final _gestaoAvaliacaoId = Rxn<int>();
  final _modeloAvaliacaoId = Rxn<int>();
  final _penalidade = Rx<double>(0.00);
  final _comentario = Rx<String>('');

  bool get isLoading => _loading.value;
  String? get errorMessage => _errorMessage.value;
  bool get hasError => _errorMessage.value != null;
  List<AvaliacaoDetailsModel> get criterios => _criterios;
  int get totalCriterios => _criterios.length;
  int get totalCriteriosCumpridos =>
      _criterios.fold(0, (previousValue, element) {
        if (element.cumprido) {
          return previousValue + 1;
        }
        return 0;
      });
  String get comentario => _comentario.value;
  double get penalidade => _penalidade.value;

  @override
  void onInit() {
    super.onInit();
    _getRouterArguments();
    loadData();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
  }

  void _getRouterArguments() {
    _gestaoAvaliacaoId.value = Get.arguments['gestaoAvaliacaoId'];
    _modeloAvaliacaoId.value = Get.arguments['modeloAvaliacaoId'];
    _comentario.value = Get.arguments['comentario'];
    _penalidade.value = Get.arguments['penalidade'];
  }

  Future<void> loadData() async {
    _errorMessage.value = null;
    _loading(true);
    _getRouterArguments();

    if (_gestaoAvaliacaoId.value == null || _modeloAvaliacaoId.value == null) {
      Get.back(closeOverlays: true, result: null);
    }

    final result = await _avaliacoesService.getCriterios(
      gestaoAvaliacaoId: _gestaoAvaliacaoId.value!,
      modeloAvaliacaoId: _modeloAvaliacaoId.value!,
    );

    if (result.isError) {
      _loading(false);
      _errorMessage(result.message);
      return;
    }

    _criterios.assignAll(result.data!);
    _loading(false);
  }
}
