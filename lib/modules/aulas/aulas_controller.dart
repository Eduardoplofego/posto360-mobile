import 'dart:developer';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/core/domain/mixins/loader_mixin.dart';
import 'package:posto360/modules/core/domain/mixins/message_mixin.dart';
import 'package:posto360/modules/core/domain/services/auth_service.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/core/domain/utils/enums/aula_status.dart';
import 'package:posto360/modules/aulas/domain/models/aula_model.dart';
import 'package:posto360/modules/aulas/domain/models/curso_model.dart';
import 'package:posto360/modules/aulas/widgets/timeline_classes_widget.dart';
import 'package:posto360/modules/cursos/domain/dtos/curso_to_aula_dto.dart';
import 'package:posto360/modules/aulas/infra/services/aulas_service.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:video_player/video_player.dart';

class AulasController extends GetxController with LoaderMixin, MessageMixin {
  final AulasService _aulasService;
  final AuthService _authService;

  AulasController({
    required AulasService aulasService,
    required AuthService authService,
  }) : _aulasService = aulasService,
       _authService = authService;

  // Observables
  final _message = Rxn<MessagesModel>();
  final _loading = false.obs;
  final _hasData = false.obs;
  final _curso = Rxn<CursoModel>();
  final _aulas = <AulaModel>[].obs;
  final _currentAulaIndex = 0.obs;
  final _currentAula = Rxn<AulaModel>();
  final _isToShowMaterialComplementar = false.obs;
  final _pdfLoaded = false.obs;
  final _isVisulizeAulaLoading = false.obs;
  final _chewieController = Rxn<ChewieController>();

  // Getters
  CursoModel? get curso => _curso.value;
  bool get isLoading => _loading.value;
  bool get hasData => _hasData.value;
  AulaModel? get currentAula => _currentAula.value;
  int get totalAulas => _aulas.length;
  int get totalAulasConcluidas =>
      _aulas.where((aula) => aula.status == AulaStatus.finalizado).length;
  int get currentAulaIndex => _currentAulaIndex.value;
  bool get isToShowMaterial => _isToShowMaterialComplementar.value;
  bool get hasPrevClass => hasData && _currentAulaIndex.value >= 1;
  bool get hasNextClass {
    if (!hasData || _aulas.isEmpty) return false;

    final currentIndex = _currentAulaIndex.value;

    if (currentIndex < 0 || currentIndex >= _aulas.length) return false;

    final hasMaterial = _aulas[currentIndex].hasMaterial;

    final nextIndex = currentIndex + 1;
    final hasNextAulaDesbloqueada =
        nextIndex < _aulas.length &&
        _aulas[nextIndex].status != AulaStatus.bloqueado;

    return hasMaterial || hasNextAulaDesbloqueada;
  }

  bool get pdfLoaded => _pdfLoaded.value;
  bool get isVisulizeAulaLoading => _isVisulizeAulaLoading.value;
  bool get videoInitialized => _chewieController.value != null;
  ChewieController? get chewieController => _chewieController.value;

  // Actions
  @override
  Future<void> onInit() async {
    super.onInit();
    messageListener(_message);
    loaderListener(_loading);
    await getCursoArgument(Get.arguments as CursoToAulaDTO?);
  }

  @override
  void onClose() {
    _disposeVideoPlayer();
    super.onClose();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    _loading(true);
    await _loadAulas();
    _loading(false);
  }

  Future<void> getCursoArgument(CursoToAulaDTO? dto) async {
    if (dto != null) {
      _curso.value = dto.curso;
    }
  }

  Future<void> _loadAulas() async {
    _loading(true);
    try {
      if (_curso.value == null) {
        _hasData(false);
        return;
      }
      final aulasDto = await _aulasService.getAulas(
        cursoId: _curso.value!.templateId,
        usuarioId: _authService.authenticatedUser!.id,
      );
      if (!aulasDto.success) {
        _hasData(false);
        _message(
          MessagesModel(
            title: 'Erro',
            message:
                aulasDto.message.isNotEmpty
                    ? aulasDto.message
                    : 'Não foi possível carregar as aulas deste curso',
            type: MessageType.error,
          ),
        );
        return;
      }
      final aulas = aulasDto.data ?? [];
      if (aulas.length > 1) aulas.sort((a, b) => a.ordem.compareTo(b.ordem));
      _aulas.assignAll(aulas);
      _hasData(aulas.isNotEmpty);
      await _loadFirstCurrentAula();
    } catch (e, s) {
      log('Erro ao carregar aulas do curso', error: e, stackTrace: s);
      _hasData(false);
      _message(
        MessagesModel(
          title: 'Erro',
          message: 'Não foi possível carregar as aulas deste curso',
          type: MessageType.error,
        ),
      );
    } finally {
      _loading(false);
    }
  }

  Future<void> _loadFirstCurrentAula() async {
    if (_aulas.isEmpty) {
      _currentAulaIndex.value = 0;
      _currentAula.value = null;
      await _disposeVideoPlayer();
      return;
    }
    final concluidas =
        _aulas.where((aula) => aula.status == AulaStatus.finalizado).length;
    await setCurrentAula(concluidas < _aulas.length ? concluidas : 0);
  }

  Future<void> setCurrentAula(int index) async {
    if (index < 0 || index >= _aulas.length) return;
    _currentAulaIndex.value = index;
    _currentAula.value = _aulas[index];
    await initializeVideoPlayer();
  }

  Future<void> showMaterialAulaWidget() async {
    _pdfLoaded(true);
  }

  Future<void> hideMaterialAulaWidget() async {
    _pdfLoaded(false);
  }

  void setPrevClass() {
    if (isToShowMaterial) {
      _isToShowMaterialComplementar(false);
    } else {
      setCurrentAula(currentAulaIndex - 1);
    }
  }

  void setNextClass() {
    final aula = currentAula;
    if (aula == null) return;

    if (aula.hasMaterial && !isToShowMaterial) {
      _isToShowMaterialComplementar(true);
    } else {
      // verificar se a aula foi concluida
      if (aula.status == AulaStatus.emAndamento) {
        _showDialogConfirmConcludeClass();
      } else {
        _isToShowMaterialComplementar(false);
        setCurrentAula(currentAulaIndex + 1);
      }
    }
  }

  void _showDialogConfirmConcludeClass() {
    Get.defaultDialog(
      title: 'Aula não finalizada!',
      titleStyle: TextStyle(
        fontSize: 18,
        color: PostoAppUiConfigurations.textDarkColor,
      ),
      titlePadding: EdgeInsets.all(16),
      content: Text(
        'Finalize a aula para avançar',
        textAlign: TextAlign.center,
        style: TextStyle(color: PostoAppUiConfigurations.greyColor),
      ),
      radius: 10,
      backgroundColor: PostoAppUiConfigurations.lightPurpleColor,
      buttonColor: PostoAppUiConfigurations.blueMediumColor,
      contentPadding: EdgeInsets.all(8),
      barrierDismissible: false,
      textConfirm: 'Entendi',
      onConfirm: () {
        Get.back(closeOverlays: true);
      },
    );
  }

  Future<void> initializeVideoPlayer() async {
    await _disposeVideoPlayer();

    final urlVideo = _currentAula.value?.urlVideo ?? '';
    if (urlVideo.isEmpty) return;

    final uri = Uri.tryParse(urlVideo);
    if (uri == null || !uri.hasScheme) {
      log('URL de vídeo inválida para a aula ${_currentAula.value?.id}: $urlVideo');
      return;
    }

    try {
      final videoPlayerController = VideoPlayerController.networkUrl(uri);
      await videoPlayerController.initialize();
      _chewieController.value = ChewieController(
        videoPlayerController: videoPlayerController,
        showControlsOnInitialize: false,
        placeholder: Container(width: 50, height: 50, color: Colors.black),
        autoPlay: false,
        looping: false,
        deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
      );
    } catch (e, s) {
      // Um vídeo indisponível não pode impedir o acesso ao restante do curso.
      log('Erro ao inicializar o vídeo da aula', error: e, stackTrace: s);
      _chewieController.value = null;
    }
  }

  Future<void> _disposeVideoPlayer() async {
    final chewie = _chewieController.value;
    if (chewie == null) return;
    _chewieController.value = null;
    final videoPlayerController = chewie.videoPlayerController;
    chewie.dispose();
    await videoPlayerController.dispose();
  }

  Future<void> visualizeAula() async {
    final aula = currentAula;
    if (aula == null) return;

    _isVisulizeAulaLoading(true);
    final result = await _aulasService.concludeAula(aulaId: aula.id);
    if (result) {
      await _loadAulas();
    } else {
      _message(
        MessagesModel(
          title: 'Erro',
          message: 'Não foi possivel concluir a aula. \nTente novamente',
          type: MessageType.error,
        ),
      );
    }
    _isVisulizeAulaLoading(false);
  }

  List<Widget> generateTimeLineItems() {
    if (_aulas.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Center(
            child: Text(
              'Nenhuma aula encontrada!',
              style: TextStyle(
                color: PostoAppUiConfigurations.textDarkColor,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ];
    }
    return _aulas.map((aula) {
      return SizedBox(
        height: 300,
        child: TimelineTile(
          isFirst: aula.ordem == 1,
          isLast: aula.ordem == _aulas.last.ordem,
          alignment: TimelineAlign.center,
          indicatorStyle: IndicatorStyle(
            height: 230,
            width: Get.width,
            indicator: TimelineClassItemWidget(
              aula: aula,
              isCurrent: currentAula?.ordem == aula.ordem,
            ),
          ),
        ),
      );
    }).toList();
  }
}
