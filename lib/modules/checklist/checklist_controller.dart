import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/core/domain/mixins/loader_mixin.dart';
import 'package:posto360/modules/core/domain/mixins/message_mixin.dart';
import 'package:posto360/modules/core/domain/services/auth_service.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/core/domain/utils/enums/checklist_status.dart';
import 'package:posto360/modules/checklist/domain/models/checklist_model.dart';
import 'package:posto360/modules/checklist/widgets/checklist_card_widget.dart';
import 'package:posto360/modules/checklist/infra/services/checklist_service.dart';

class ChecklistController extends GetxController
    with LoaderMixin, MessageMixin {
  final ChecklistService _checklistService;

  ChecklistController({required ChecklistService checklistService})
    : _checklistService = checklistService;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    _loading(true);
    await _loadChecklists();
    _loading(false);
  }

  Future<void> onRefresh() async {
    _loading(true);
    await _loadChecklists();
    _loading(false);
  }

  // Observables
  final _loading = false.obs;
  final _message = Rxn<MessagesModel>();
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

  Future<bool> _tryStartChecklist({required int checklistId}) async {
    final userAuthenticated = Get.find<AuthService>().authenticatedUser;
    if (userAuthenticated != null) {
      final resultStart = await _checklistService.startChecklist(
        usuarioId: userAuthenticated.id,
        checklistId: checklistId,
      );
      if (resultStart.isError) {
        _message(
          MessagesModel(
            title: 'Erro',
            message: resultStart.message,
            type: MessageType.error,
          ),
        );
        return false;
      }
      return true;
    }
    return false;
  }

  Future<bool> showDialogToStartChecklist(int checklistId) async {
    bool isToStartChecklist = false;
    final response = await Get.defaultDialog<bool>(
      title: 'Iniciando checklist...',
      titleStyle: TextStyle(
        fontSize: 18,
        color: PostoAppUiConfigurations.textDarkColor,
      ),
      titlePadding: EdgeInsets.all(16),
      radius: 10,
      middleText: 'Deseja iniciar esta checklist?',
      content: null,
      backgroundColor: PostoAppUiConfigurations.lightPurpleColor,
      buttonColor: PostoAppUiConfigurations.blueMediumColor,
      contentPadding: EdgeInsets.all(8),
      barrierDismissible: true,
      textConfirm: 'Iniciar',
      onConfirm: () async {
        final resultStart = await _tryStartChecklist(checklistId: checklistId);
        Get.back<bool>(result: resultStart);
      },
      textCancel: 'Não',
      onCancel: () {
        return;
      },
    );
    return response ?? isToStartChecklist;
  }
}
