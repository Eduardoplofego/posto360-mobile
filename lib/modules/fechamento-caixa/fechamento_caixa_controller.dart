import 'package:get/get.dart';
import 'package:posto360/modules/core/domain/mixins/message_mixin.dart';
import 'package:posto360/modules/core/domain/services/auth_service.dart';
import 'package:posto360/modules/fechamento-caixa/domain/adapters/month_adapter.dart';
import 'package:posto360/modules/fechamento-caixa/domain/models/detalhes_cartoes_model.dart';
import 'package:posto360/modules/fechamento-caixa/infra/services/fechamento_caixa_service.dart';

class FechamentoCaixaController extends GetxController with MessageMixin {
  final AppFechamentoCaixaService _fechamentoCaixaService;
  final AuthService _authService;

  FechamentoCaixaController({
    required AppFechamentoCaixaService fechamentoCaixaService,
    required AuthService authService,
  }) : _fechamentoCaixaService = fechamentoCaixaService,
       _authService = authService;

  // Observables
  final _message = Rxn<MessagesModel>();
  final _monthSelected = DateTime.now().obs;
  final _loadingCards = false.obs;
  final _cardList = <DetalhesCartoesModel>[].obs;

  final _totalCartoesDeletados = 0.obs;
  final _totalCartoesVinculados = 0.obs;
  final _totalCartoesCorrigidos = 0.obs;
  final _diferencaTotal = 0.00.obs;

  // Getters
  DateTime get monthSelected => _monthSelected.value;
  String get monthSelectedText =>
      '${getMonthText(monthSelected.month)} ${monthSelected.year}';
  bool get hasNextMonth =>
      monthSelected.month != DateTime.now().month &&
      monthSelected.year == DateTime.now().year;
  bool get loadingCards => _loadingCards.value;
  List<DetalhesCartoesModel> get cardList => _cardList;

  int get totalCartoesDeletados => _totalCartoesDeletados.value;
  int get totalCartoesVinculados => _totalCartoesVinculados.value;
  int get totalCartoesCorrigidos => _totalCartoesCorrigidos.value;
  double get diferencaTotal => _diferencaTotal.value;

  @override
  void onInit() {
    messageListener(_message);
    _selectMonthByParameter();
    super.onInit();
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

  @override
  Future<void> onReady() async {
    super.onReady();
    await _loadMonthCards();
  }

  Future<void> _loadMonthCards() async {
    _loadingCards(true);
    final result = await _fechamentoCaixaService.getFechamentoDetalhes(
      usuarioId: _authService.authenticatedUser?.id ?? '',
      dataMes: monthSelected,
    );
    if (result.isError || result.data == null) {
      _message(
        MessagesModel(
          title: 'Erro',
          message: result.message,
          type: MessageType.error,
        ),
      );
      _cardList.assignAll([]);
      return;
    }
    _cardList.assignAll(result.data!);
    _countCardsInfos();
    _loadingCards(false);
  }

  void _countCardsInfos() {
    for (var card in cardList) {
      _totalCartoesDeletados.value += card.cartoesCorrigidos;
      _totalCartoesCorrigidos.value += card.cartoesCorrigidos;
      _totalCartoesVinculados.value += card.cartoesVinculados;
      _diferencaTotal.value += card.diferenca;
    }
  }
}
