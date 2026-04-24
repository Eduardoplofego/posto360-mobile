import 'package:get/get.dart';
import 'package:posto360/modules/dash/dash_controller.dart';
import 'package:posto360/modules/equipe/domain/models/resumo_equipe_model.dart';
import 'package:posto360/modules/equipe/infra/services/equipe_service.dart';

class DashGerenteController extends DashController {
  final EquipeService _equipeService;

  DashGerenteController({required EquipeService equipeService})
    : _equipeService = equipeService;

  final _loadingResumoEquipe = false.obs;
  final _resumoEquipe = Rx<ResumoEquipeModel>(ResumoEquipeModel.empty());
  final _hasResumoEquipe = false.obs;

  bool get loadingResumoEquipe => _loadingResumoEquipe.value;
  ResumoEquipeModel get resumoEquipe => _resumoEquipe.value;
  bool get hasResumoEquipe => _hasResumoEquipe.value;

  @override
  double get penalidadeTotal =>
      super.penalidadeTotal + resumoEquipe.penalidade;

  @override
  void onReady() async {
    super.onReady();
    await loadResumoEquipe();
  }

  Future<void> loadResumoEquipe() async {
    final filialId = autheticatedUser.idFilial;
    if (filialId == null) {
      _hasResumoEquipe(false);
      return;
    }
    _loadingResumoEquipe(true);
    final result = await _equipeService.getResumo(
      dataAtual: monthSelected,
      filialId: filialId,
    );
    if (result.success) {
      _resumoEquipe.value = result.data ?? ResumoEquipeModel.empty();
      _hasResumoEquipe(true);
    } else {
      _hasResumoEquipe(false);
    }
    _loadingResumoEquipe(false);
  }

  @override
  Future<void> onRefresh() async {
    await Future.wait([super.onRefresh(), loadResumoEquipe()]);
  }

  @override
  Future<void> prevMonth(DateTime monthSelected) async {
    await super.prevMonth(monthSelected);
    await loadResumoEquipe();
  }

  @override
  Future<void> nextMonth(DateTime monthSelected) async {
    await super.nextMonth(monthSelected);
    await loadResumoEquipe();
  }
}
