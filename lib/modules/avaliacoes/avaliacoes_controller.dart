import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:posto360/modules/avaliacoes/domain/models/avaliacoes_model.dart';
import 'package:posto360/modules/avaliacoes/infra/services/avaliacoes_module_service.dart';
import 'package:posto360/modules/core/domain/constants/constants.dart';
import 'package:posto360/modules/core/domain/models/user_model.dart';

class AvaliacoesController extends GetxController {
  late AvaliacoesModuleService _avaliacoesService;

  AvaliacoesController() {
    _avaliacoesService = Get.find<AvaliacoesModuleService>();
  }

  final _loading = false.obs;

  final _isAvaliadoSelected = true.obs;
  final _avaliationsList = <AvaliacoesModel>[].obs;
  final _monthSelected = DateTime.now().obs;
  final _userAuthenticated = Rx<UserModel>(UserModel.empty());

  bool get isLoading => _loading.value;
  bool get isAvaliadoSelected => _isAvaliadoSelected.value;
  List<AvaliacoesModel> get avaliationsList => _avaliationsList;
  int get totalAvaliationsConcluded {
    if (avaliationsList.isEmpty) return 0;
    return avaliationsList.where((a) => a.isConcluded).length;
  }

  int get totalPendingAvaliations =>
      avaliationsList.isEmpty
          ? 0
          : avaliationsList.length - totalAvaliationsConcluded;

  Future<void> onLeftTabPressed() async {
    _isAvaliadoSelected(true);
  }

  Future<void> onRightTabPressed() async {
    _isAvaliadoSelected(false);
  }

  @override
  void onInit() {
    super.onInit();
    _selectMonthByParameter();
    _initInfos();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await _loadList();
  }

  Future<void> _initInfos() async {
    _userAuthenticated.value = UserModel.fromMap(
      GetStorage().read(Constants.USER_KEY),
    );
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

  Future<void> _loadList() async {
    _loading(true);
    final avaliacoes = await _avaliacoesService.getAvaliacoesAvaliado(
      dataMes: _monthSelected.value,
      usuarioId: _userAuthenticated.value.id,
    );
    if (avaliacoes.isError) {
      return;
    }
    _avaliationsList.assignAll(avaliacoes.data!);
    _loading(false);
  }
}
