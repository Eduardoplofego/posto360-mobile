import 'package:get/get.dart';
import 'package:posto360/modules/procedimentos/domain/models/procedimento_model.dart';
import 'package:posto360/modules/procedimentos/infra/mock/procedimentos_mock.dart';

class ProcedimentoDetalheController extends GetxController {
  final int procedimentoId;

  ProcedimentoDetalheController({required this.procedimentoId});

  final _loading = false.obs;
  final _procedimento = Rxn<ProcedimentoModel>();
  final _expanded = <int>{}.obs;

  bool get isLoading => _loading.value;
  ProcedimentoModel? get procedimento => _procedimento.value;
  Set<int> get expandedEtapas => _expanded;

  @override
  Future<void> onReady() async {
    super.onReady();
    await _loadDetalhe();
  }

  Future<void> onRefresh() async {
    await _loadDetalhe();
  }

  Future<void> _loadDetalhe() async {
    _loading.value = true;
    await Future.delayed(const Duration(milliseconds: 300));
    final data = ProcedimentosMock.detalhes();
    final match = (data['procedimentos'] as List).cast<Map<String, dynamic>>()
        .firstWhereOrNull((e) => (e['id']?.toInt() ?? -1) == procedimentoId);
    if (match != null) {
      final model = ProcedimentoModel.fromMap(match);
      _procedimento.value = model;
      if (model.etapas.isNotEmpty) {
        _expanded.add(model.etapas.first.id);
      }
    } else {
      _procedimento.value = null;
    }
    _loading.value = false;
  }

  bool isEtapaExpanded(int etapaId) => _expanded.contains(etapaId);

  void toggleEtapa(int etapaId) {
    if (_expanded.contains(etapaId)) {
      _expanded.remove(etapaId);
    } else {
      _expanded.add(etapaId);
    }
  }
}
