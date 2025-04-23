import 'package:get/get.dart';
import 'package:posto360/core/mixins/loader_mixin.dart';
import 'package:posto360/core/services/auth_service.dart';
import 'package:posto360/models/checklist_answer_model.dart';
import 'package:posto360/services/checklists/checklist_service.dart';

class ChecklistAnswerController extends GetxController with LoaderMixin {
  final ChecklistService _checklistService;

  ChecklistAnswerController({required ChecklistService checklistService})
    : _checklistService = checklistService;

  // Observables
  final _checklistName = ''.obs;
  final _checklistId = 0.obs;
  final _loader = false.obs;
  final _answersList = <ChecklistAnswerModel>[].obs;
  final _isToConcludedSelect = true.obs;

  final _cardOptionSelectedIndex = RxnInt(1);

  // Getters
  bool get isLoading => _loader.value;
  String get checklistName => _checklistName.value;
  bool get hasAnswers => _answersList.isEmpty;
  int get checklistId => _checklistId.value;
  bool get isToConcludedSelect => _isToConcludedSelect.value;
  List<ChecklistAnswerModel> get listToShow =>
      isToConcludedSelect ? toConcludedAnswersList : concludedAnswersList;
  List<ChecklistAnswerModel> get toConcludedAnswersList =>
      _answersList.where((answer) => !answer.respostaDada).toList();
  List<ChecklistAnswerModel> get concludedAnswersList =>
      _answersList.where((answer) => answer.respostaDada).toList();
  int get totalConcludedAnswers => concludedAnswersList.length;
  int get totalToConcludeAnswers => toConcludedAnswersList.length;
  int? get cardOptionSelectedIndex => _cardOptionSelectedIndex.value;

  // Actions
  @override
  void onInit() {
    super.onInit();
    loaderListener(_loader);
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    _getRoutesArguments();
    _loader(true);
    await _loadChecklistAnswers();
    _loader(false);
  }

  void changeSelectTab() {
    _isToConcludedSelect.toggle();
  }

  void _getRoutesArguments() {
    final checklist = Get.parameters;
    _checklistName.value = checklist['name'] as String;
    _checklistId.value = int.tryParse(checklist['id'].toString()) ?? 0;
  }

  Future<void> _loadChecklistAnswers() async {
    final userAuth = Get.find<AuthService>().authenticatedUser;
    if (userAuth != null && _checklistId.value != 0) {
      final result = await _checklistService.checklistAnswer(
        usuarioId: userAuth.id,
        checklistId: _checklistId.value,
      );
      _answersList.value = result.data!;
    }
  }

  void checkAnswerCard(int? index) {
    _cardOptionSelectedIndex.value = index;
  }
}
