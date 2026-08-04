import 'package:get/get.dart';
import 'package:posto360/modules/core/domain/mixins/message_mixin.dart';
import 'package:posto360/modules/core/domain/services/auth_service.dart';
import 'package:posto360/modules/fechamento-caixa/domain/models/cartao_discrepancia_model.dart';
import 'package:posto360/modules/fechamento-caixa/infra/services/fechamento_caixa_service.dart';

class CartoesDetalhesController extends GetxController with MessageMixin {
  final AppFechamentoCaixaService _fechamentoCaixaService;
  final AuthService _authService;

  CartoesDetalhesController({
    required AppFechamentoCaixaService fechamentoCaixaService,
    required AuthService authService,
  }) : _fechamentoCaixaService = fechamentoCaixaService,
       _authService = authService;

  final _message = Rxn<MessagesModel>();
  final _dia = Rxn<DateTime>();
  final _loading = false.obs;
  final _cartoes = <CartaoDiscrepanciaModel>[].obs;

  DateTime? get dia => _dia.value;
  bool get loading => _loading.value;
  List<CartaoDiscrepanciaModel> get cartoes => _cartoes;

  int get totalCartoes => _cartoes.length;

  /// Quantidade de cartoes por status, na ordem em que aparecem na lista.
  Map<String, int> get totalPorStatus {
    final totais = <String, int>{};
    for (final cartao in _cartoes) {
      totais.update(
        cartao.statusLabel,
        (valor) => valor + 1,
        ifAbsent: () => 1,
      );
    }
    return totais;
  }

  @override
  void onInit() {
    messageListener(_message);
    _selecionarDiaPorParametro();
    super.onInit();
  }

  void _selecionarDiaPorParametro() {
    final parametro = Get.parameters['dia'];
    if (parametro == null) return;
    _dia(DateTime.tryParse(parametro));
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await carregarCartoes();
  }

  Future<void> carregarCartoes() async {
    final diaSelecionado = dia;

    if (diaSelecionado == null) {
      _message(
        MessagesModel(
          title: 'Erro',
          message: 'Dia inválido para consultar os cartões',
          type: MessageType.error,
        ),
      );
      return;
    }

    _loading(true);

    final result = await _fechamentoCaixaService.getCartoesDoDia(
      usuarioId: _authService.authenticatedUser?.id ?? '',
      dia: diaSelecionado,
    );

    _loading(false);

    if (result.isError || result.data == null) {
      _message(
        MessagesModel(
          title: 'Erro',
          message: result.message,
          type: MessageType.error,
        ),
      );
      _cartoes.assignAll([]);
      return;
    }

    _cartoes.assignAll(result.data!);
  }
}
