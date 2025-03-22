import 'package:get/get.dart';
import 'package:posto360/core/mixins/loader_mixin.dart';
import 'package:posto360/core/mixins/message_mixin.dart';
import 'package:posto360/core/services/auth_service.dart';
import 'package:posto360/core/utils/data_formatters.dart';
import 'package:posto360/models/campanha_model.dart';
import 'package:posto360/models/performance_model.dart';
import 'package:posto360/modules/campanhas/widgets/campanha_card_widget.dart';
import 'package:posto360/services/campanhas/campanhas_service.dart';
import 'package:posto360/services/performance/performance_service.dart';

class CampanhasController extends GetxController
    with MessageMixin, LoaderMixin {
  final CampanhasService _campanhasService;
  final PerformanceService _performanceService;
  final AuthService _authService;

  CampanhasController({
    required CampanhasService campanhaService,
    required AuthService authService,
    required PerformanceService performanceService,
  }) : _campanhasService = campanhaService,
       _authService = authService,
       _performanceService = performanceService;

  // Observables
  final _message = Rxn<MessagesModel>();
  final _loader = false.obs;
  final _campanhasList = <CampanhaModel>[].obs;
  final _valueTotalBonus = 0.0.obs;
  final _periodSelected = <DateTime>[DateTime.now(), DateTime(2025, 3, 1)].obs;
  final _periodSelectedString = ''.obs;
  final _performancesList = <PerformanceModel>[].obs;
  final _performancesListMap = <int, dynamic>{}.obs;

  // Getters
  List<CampanhaModel> get campanhas => _campanhasList;
  List<PerformanceModel> get performances => _performancesList;
  bool get isLoading => _loader.value;
  double get valueTotalBonus => _valueTotalBonus.value;
  List<DateTime> get periodSelected => _periodSelected;
  String get periodSelectedString => _periodSelectedString.value;
  Map<int, dynamic> get performancesListMap => _performancesListMap;

  // Actions
  @override
  void onInit() {
    messageListener(_message);
    loaderListener(_loader);
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    _loader(true);
    await _loadCampanhas();
    await _loadPerformances();
    transformPeriodToString();
    _loader(false);
  }

  Future<void> _loadCampanhas() async {
    final campanhas = await _campanhasService.getAllCampanhas(
      filialId: _authService.authenticatedUser!.idFilial!,
      tipoUsuario: _authService.authenticatedUser!.tipoUsuario,
    );
    if (campanhas.isError) {
      _message(
        MessagesModel(
          title: 'Erro',
          message: campanhas.message,
          type: MessageType.error,
        ),
      );
    }
    _campanhasList.assignAll(campanhas.data!);
  }

  Future<void> _loadPerformances() async {
    final campanhasIds =
        _campanhasList.map<int>((campanha) => campanha.campanhaId).toList();
    final performances = await _performanceService.getPerformances(
      codigoFuncionario: _authService.authenticatedUser!.codigoPDV.toString(),
      campanhasId: campanhasIds,
    );
    if (performances.isError) {
      _message(
        MessagesModel(
          title: 'Erro',
          message: performances.message,
          type: MessageType.error,
        ),
      );
    }
    for (var performance in performances.data!) {
      _performancesList.add(performance);
      final mapEntrie = performance.toMap();
      _performancesListMap.addEntries(mapEntrie.entries);

      final campanhaPerformance =
          _campanhasList
              .where(
                (campanha) => campanha.campanhaId == performance.campanhaId,
              )
              .first;
      final targetToWin =
          campanhaPerformance.tipoBonificacao == TypeBonificacao.unidade
              ? campanhaPerformance.volumeBonificacao.toDouble()
              : campanhaPerformance.valorBonificacao *
                  campanhaPerformance.valorBonificacao;
      final currentTaken =
          campanhaPerformance.tipoBonificacao == TypeBonificacao.unidade
              ? performance.unidadesVendidas.toDouble()
              : (performance.unidadesVendidas *
                  campanhaPerformance.valorBonificacao);

      if (targetToWin <= currentTaken) {
        _loadTotalBonus(currentTaken);
      }
    }
  }

  List<CampanhaCardWidget> loadCampanhaCards() {
    if (_campanhasList.isEmpty) return [];
    return _campanhasList.map((campanha) {
      return CampanhaCardWidget(
        campanha: campanha,
        performace: performancesListMap[campanha.campanhaId],
      );
    }).toList();
  }

  void transformPeriodToString() {
    _periodSelectedString.value = DataFormatters.formatarPeriodo(
      _periodSelected,
    );
  }

  void _loadTotalBonus(double value) {
    _valueTotalBonus.value += value;
  }
}
