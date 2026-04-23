import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:posto360/modules/avaliacoes/domain/models/avaliacoes_avaliador_model.dart';
import 'package:posto360/modules/avaliacoes/domain/models/avaliacoes_model.dart';
import 'package:posto360/modules/avaliacoes/domain/models/user_model.dart';
import 'package:posto360/modules/avaliacoes/infra/services/avaliacoes_module_service.dart';
import 'package:posto360/modules/avaliacoes/pages/sub_pages/select_users_page.dart';
import 'package:posto360/modules/core/domain/constants/constants.dart';
import 'package:posto360/modules/core/domain/mixins/message_mixin.dart';
import 'package:posto360/modules/core/domain/models/user_model.dart';

class AvaliacoesController extends GetxController with MessageMixin {
  late AvaliacoesModuleService _avaliacoesService;

  AvaliacoesController() {
    _avaliacoesService = Get.find<AvaliacoesModuleService>();
  }

  final _loading = false.obs;
  final _message = Rxn<MessagesModel>();

  final _laodingAvaliation = false.obs;
  final _loadingAvaliationIndex = 0.obs;

  final _isAvaliadoSelected = true.obs;
  final _avaliationsList = <AvaliacoesModel>[].obs;
  final _avaliacoesAvaliador = <AvaliacaoAvaliador>[].obs;
  final _monthSelected = DateTime.now().obs;
  final _userAuthenticated = Rx<UserModel>(UserModel.empty());

  bool get isLoadingAvaliation => _laodingAvaliation.value;
  int get isLoadingAvaliationIndex => _loadingAvaliationIndex.value;

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
  List<AvaliacaoAvaliador> get avaliadorAvaliacoes => _avaliacoesAvaliador;
  int get totalAvaliacoesAvaliadorPendentes =>
      _avaliacoesAvaliador.whereType<AvaliacaoPendente>().length;
  int get totalAvaliacoesAvaliadorFinalizadas =>
      _avaliacoesAvaliador.whereType<AvaliacaoFinalizada>().length;
  bool _avaliacoesAvaliadorLoaded = false;

  Future<void> onLeftTabPressed() async {
    _isAvaliadoSelected(true);
  }

  Future<void> onRightTabPressed() async {
    if (!_avaliacoesAvaliadorLoaded) {
      await loadAvaliacoesAvaliador();
    }
    _isAvaliadoSelected(false);
  }

  @override
  void onInit() {
    super.onInit();
    messageListener(_message);
    _selectMonthByParameter();
    _initInfos();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await loadList();
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

  Future<void> loadList() async {
    _loading(true);
    final avaliacoes = await _avaliacoesService.getAvaliacoesAvaliado(
      dataMes: _monthSelected.value,
      usuarioId: _userAuthenticated.value.id,
    );
    if (avaliacoes.isError) {
      _loading(false);
      return;
    }
    _avaliationsList.assignAll(avaliacoes.data!);
    _loading(false);
  }

  Future<List<UserAvaliationModel>?> getUsers(int avaliacaoId) async {
    final usersResult = await _avaliacoesService.getUsers(
      avaliacaoId: avaliacaoId,
    );

    if (usersResult.isError) {
      _laodingAvaliation(false);
      _message(
        MessagesModel(
          title: 'Erro',
          message: 'Erro ao carregar usuários',
          type: MessageType.error,
        ),
      );
      return null;
    }
    _laodingAvaliation(false);
    return usersResult.data;
  }

  Future<void> loadAvaliacoesAvaliador() async {
    _loading(true);
    await Future.delayed(const Duration(seconds: 1));
    final avaliacoes = await _avaliacoesService.getAvaliacoesAvaliador(
      dataMes: _monthSelected.value,
      usuarioId: _userAuthenticated.value.id,
    );

    if (avaliacoes.isError) {
      _loading(false);
      return;
    }

    await _avaliacoesService.getUsers(avaliacaoId: 1);

    _avaliacoesAvaliador.assignAll(avaliacoes.data!);
    _avaliacoesAvaliadorLoaded = true;
    _loading(false);
  }

  Future<void> navigateToDiscretionsPage(AvaliacaoPendente avaliation) async {
    if (avaliation.avaliadoId != null) {
      // ir para pagina de criterios
      // return;
    }

    final userSelected = await _getUserToAvaliation(avaliation.id);

    if (userSelected == null) return;

    final resultDefine = await _defineUser(avaliation.id, userSelected.id);

    if (resultDefine != null) {
      _message(
        MessagesModel(
          title: 'Erro',
          message: resultDefine,
          type: MessageType.error,
        ),
      );
    }
  }

  Future<UserAvaliationModel?> _getUserToAvaliation(int avaliacaoId) async {
    final users = await getUsers(avaliacaoId);

    if (users == null) return null;

    final selectedUser = await Get.to<UserAvaliationModel>(
      () => SelectUsersPage(users: users),
    );

    return selectedUser;
  }

  Future<String?> _defineUser(int avaliacaoId, String userId) async {
    final result = await _avaliacoesService.setUser(
      avaliacaoId: avaliacaoId,
      usuarioId: userId,
    );

    if (result.isError) return 'Ocorreu um erro ao definir usuário';

    return null;
  }
}
