import 'package:get/get.dart';
import 'package:posto360/modules/procedimentos/domain/models/procedimento_model.dart';
import 'package:posto360/modules/procedimentos/infra/mock/procedimentos_mock.dart';

class ProcedimentosController extends GetxController {
  final _loading = false.obs;
  final _procedimentos = <ProcedimentoModel>[].obs;

  bool get isLoading => _loading.value;
  List<ProcedimentoModel> get procedimentos => _procedimentos.toList();

  @override
  Future<void> onReady() async {
    super.onReady();
    await _loadProcedimentos();
  }

  Future<void> onRefresh() async {
    await _loadProcedimentos();
  }

  Future<void> _loadProcedimentos() async {
    _loading.value = true;
    await Future.delayed(const Duration(milliseconds: 300));
    final data = ProcedimentosMock.lista();
    final list = (data['procedimentos'] as List)
        .map((e) => ProcedimentoModel.fromMap(e as Map<String, dynamic>))
        .toList();
    _procedimentos.assignAll(list);
    _loading.value = false;
  }
}
