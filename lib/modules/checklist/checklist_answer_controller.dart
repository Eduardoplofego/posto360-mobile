import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:posto360/modules/core/domain/dto/image_answer_dto.dart';
import 'package:posto360/modules/core/domain/mixins/loader_mixin.dart';
import 'package:posto360/modules/core/domain/mixins/message_mixin.dart';
import 'package:posto360/modules/core/domain/services/auth_service.dart';
import 'package:posto360/modules/core/domain/utils/enums/checklist_answer_tipo.dart';
import 'package:posto360/modules/checklist/domain/models/checklist_answer_model.dart';
import 'package:posto360/modules/checklist/infra/services/checklist_service.dart';

class ChecklistAnswerController extends GetxController
    with LoaderMixin, MessageMixin {
  final ChecklistService _checklistService;

  ChecklistAnswerController({required ChecklistService checklistService})
    : _checklistService = checklistService;

  // Observables
  final _checklistName = ''.obs;
  final _checklistId = 0.obs;
  final _loader = false.obs;
  final _message = Rxn<MessagesModel>();
  final _answersList = <ChecklistAnswerModel>[].obs;
  final _isToConcludedSelect = true.obs;

  final _cardOptionSelectedIndex = RxnInt(-1);

  final _selectedImagePath = ''.obs;
  final _hasSelectedImage = false.obs;
  final _answerSelected = Rxn<ChecklistAnswerModel>();

  final _loadingImageBase64 = false.obs;
  final _loadingSendAnswer = false.obs;
  final _imageAnswerDto = Rxn<ImageAnswerDto>();
  final _yesNoOptionSelected = Rxn<bool>();

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
  String get selectedImagePath => _selectedImagePath.value;
  bool get hasImageSelected => _hasSelectedImage.value;
  ChecklistAnswerModel? get answerSelected => _answerSelected.value;
  bool get isLoadingImageBase64 => _loadingImageBase64.value;
  ImageAnswerDto? get imageAnswerDto => _imageAnswerDto.value;
  bool get isLoadingSendAnswer => _loadingSendAnswer.value;
  bool get canConcludeChecklist => totalToConcludeAnswers == 0;

  // Actions
  @override
  void onInit() {
    super.onInit();
    loaderListener(_loader);
    messageListener(_message);
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    _getRoutesArguments();
    _loader(true);
    await _loadChecklistAnswers();
    _loader(false);
  }

  Future<void> onRefresh() async {
    _loader(true);
    await _loadChecklistAnswers();
    _loader(false);
  }

  @override
  void onClose() {
    super.onClose();
    disposeVaribales();
  }

  void selectedYesNoQuestion(bool value) {
    _yesNoOptionSelected(value);
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

  Future<void> openCameraScreenAndTakePhoto() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);

    if (image != null) {
      await _saveImagePathA(image.path);
    }
  }

  Future<void> _saveImagePathA(String imagePath) async {
    File imageFile = File(imagePath);

    final imageName = _getImageName(imageFile.path);
    final mimeType = lookupMimeType(imagePath);
    if (mimeType == null) {
      debugPrint('Mime type não encontrado para a imagem: $imagePath');
      return;
    }
    // String imageBase64 = await _getImageBase64(imageFile);
    Uint8List imageRaw = await imageFile.readAsBytes();

    if (imageRaw.isNotEmpty) {
      _imageAnswerDto.value = ImageAnswerDto(
        name: imageName,
        imageRaw: imageRaw,
        type: mimeType,
      );
      _hasSelectedImage(true);
    }
  }

  String _getImageName(String imagePath) {
    final nameUser = Get.find<AuthService>().getUser()?.name ?? '';
    final nameUserReplace = nameUser.replaceAll(' ', '_');
    final now = DateTime.now();
    final nowStringFormated = DateFormat('yyyy_MM_dd', 'pt_BR').format(now);
    final nowStringFormatedHour = DateFormat('HH_mm_ss', 'pt_BR').format(now);
    final imageName =
        '$nameUserReplace-$nowStringFormated-$nowStringFormatedHour.jpg';
    return imageName;
  }

  void selectAnswerModel(ChecklistAnswerModel? answer) {
    _answerSelected.value = answer;
  }

  void disposeVaribales() {
    _selectedImagePath.value = '';
    _yesNoOptionSelected.value = null;
    _hasSelectedImage(false);
  }

  dynamic _getAnswerByType(ChecklistAnswerModel answerModel, String comment) {
    switch (answerModel.tipo) {
      case ChecklistAnswerTipo.texto:
        return comment;
      case ChecklistAnswerTipo.opcoes:
        return answerModel.opcoes![cardOptionSelectedIndex!];
      case ChecklistAnswerTipo.numerico:
        return num.tryParse(comment) ?? '';
      case ChecklistAnswerTipo.boolean:
        return _yesNoOptionSelected.value;
    }
  }

  bool _validateForm(ChecklistAnswerModel answerModel, String comment) {
    switch (answerModel.tipo) {
      case ChecklistAnswerTipo.texto:
        return comment.isNotEmpty;
      case ChecklistAnswerTipo.opcoes:
        return cardOptionSelectedIndex != null;
      case ChecklistAnswerTipo.numerico:
        return comment.isNotEmpty;
      case ChecklistAnswerTipo.boolean:
        return _yesNoOptionSelected.value != null;
    }
  }

  void showConcludedTaskMessage() {
    _message(
      MessagesModel(
        title: 'Sucesso',
        message: 'Resposta enviada com sucesso',
        type: MessageType.info,
      ),
    );
  }

  Future<void> concludeChecklistAnswer({
    required ChecklistAnswerModel answerModel,
    String comment = '',
  }) async {
    _loadingSendAnswer(true);
    final isFormValid = _validateForm(answerModel, comment);
    if (!isFormValid) {
      _message(
        MessagesModel(
          title: 'Atenção',
          message: 'Nenhuma resposta foi feita',
          type: MessageType.info,
        ),
      );
      _loadingSendAnswer(false);
      return;
    }

    String? photoUrl;
    if (imageAnswerDto != null) {
      final resultPhotoUrl = await _checklistService.subirImagem(
        respostaId: answerModel.id,
        imageAnswer: imageAnswerDto!,
      );

      if (resultPhotoUrl.isError) {
        _loadingSendAnswer(false);
        _message(
          MessagesModel(
            title: 'Erro',
            message: 'Não foi possível enviar sua resposta',
            type: MessageType.error,
          ),
        );
        return;
      }
      photoUrl = resultPhotoUrl.data;
    }

    var resposta = _getAnswerByType(answerModel, comment);

    final resultSendAnswer = await _checklistService.pushChecklistAnswer(
      respostaId: answerModel.id,
      resposta: resposta,
      observacoes: comment,
      photoUrl: photoUrl,
      necessitaRevisao: answerModel.necessitaRevisao,
    );

    if (resultSendAnswer.isError) {
      _loadingSendAnswer(false);
      _message(
        MessagesModel(
          title: 'Erro',
          message: 'Não foi possível salvar a resposta',
          type: MessageType.error,
        ),
      );
      return;
    }
    _loadingSendAnswer(false);
    Get.back(result: true);
  }

  Future<void> concludedChecklist() async {
    final result = await _checklistService.finalizarChecklist(
      checklistId: checklistId,
    );

    if (result.isError) {
      _message(
        MessagesModel(
          title: 'Erro',
          message: result.message,
          type: MessageType.error,
        ),
      );
    }

    Get.back();
  }
}
