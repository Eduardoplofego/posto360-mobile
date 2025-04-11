import 'package:get/get.dart';
import 'package:posto360/core/mixins/loader_mixin.dart';
import 'package:posto360/core/services/auth_service.dart';
import 'package:posto360/core/utils/enums/checklist_status.dart';
import 'package:posto360/models/checklist_model.dart';
import 'package:posto360/modules/checklist/widgets/checklist_card_widget.dart';
import 'package:posto360/services/checklists/checklist_service.dart';

class ChecklistController extends GetxController with LoaderMixin {
  final ChecklistService _checklistService;

  ChecklistController({required ChecklistService checklistService})
    : _checklistService = checklistService;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    _loading(true);
    await _loadChecklists();
    _loading(false);
  }

  // Observables
  final _loading = false.obs;
  final _checklists = <ChecklistModel>[].obs;
  final _isRunningChecklistSelected = true.obs;

  // Getters
  List<ChecklistModel> get concludedChecklists =>
      _checklists
          .where((checklist) => checklist.status == ChecklistStatus.finalizado)
          .toList();
  List<ChecklistModel> get runningChecklists =>
      _checklists
          .where((checklist) => checklist.status != ChecklistStatus.finalizado)
          .toList();
  List<ChecklistModel> get getChecklistSelected =>
      isRunningChecklistSelected ? runningChecklists : concludedChecklists;
  int get checklistsConcluded => concludedChecklists.length;
  int get checklistRunning => runningChecklists.length;
  bool get isRunningChecklistSelected => _isRunningChecklistSelected.value;

  // Actions
  Future<void> _loadChecklists() async {
    final userAuthenticated = Get.find<AuthService>().authenticatedUser;
    if (userAuthenticated != null) {
      final result = await _checklistService.getChechlists(
        usuarioId: userAuthenticated.id,
        filialId: userAuthenticated.idFilial!,
      );
      if (result.success) {
        _checklists.assignAll(result.data!);
      }
    }
  }

  void selectChecklist(bool value) {
    _isRunningChecklistSelected.value = value;
  }

  List<ChecklistCardWidget> getChecklistCards() {
    final listSelected =
        isRunningChecklistSelected ? runningChecklists : concludedChecklists;
    return listSelected
        .map((checklist) => ChecklistCardWidget(checklist: checklist))
        .toList();
  }
}
