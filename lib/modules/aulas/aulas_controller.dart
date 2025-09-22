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
  }

  @override
  void onClose() {
    super.onClose();
    chewieController?.dispose();
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
    if (_curso.value != null) {
      final aulasDto = await _aulasService.getAulas(
        cursoId: _curso.value!.templateId,
        usuarioId: _authService.authenticatedUser!.id,
      );
      if (aulasDto.success) {
        final aulas = aulasDto.data!;
        if (aulas.length > 1) aulas.sort((a, b) => a.ordem.compareTo(b.ordem));
        _aulas.assignAll(aulas);
        await _loadFirstCurrentAula();
        if (aulas.isEmpty) {
          _hasData(false);
        } else {
          _hasData(true);
        }
      }
    }
    _loading(false);
  }

  Future<void> _loadFirstCurrentAula() async {
    int current = 0;
    for (var aula in _aulas) {
      if (aula.status == AulaStatus.finalizado) {
        current++;
      }
    }
    if (current < _aulas.length) {
      _currentAulaIndex.value = current;
      _currentAula.value = _aulas[_currentAulaIndex.value];
      if (_currentAula.value != null) {
        await initializeVideoPlayer();
      }
    } else {
      _currentAulaIndex.value = 0;
      _currentAula.value = _aulas[_currentAulaIndex.value];
      if (_currentAula.value != null) {
        await initializeVideoPlayer();
      }
    }
  }

  Future<void> setCurrentAula(int index) async {
    _currentAulaIndex.value = index;
    _currentAula.value = _aulas[index];
    if (_currentAula.value != null && _currentAula.value!.urlVideo != '') {
      await initializeVideoPlayer();
    }
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
      debugPrint(
        'Definindo aula atual para: Aula${_aulas[_currentAulaIndex.value - 1].ordem}',
      );
      setCurrentAula(currentAulaIndex - 1);
    }
  }

  void setNextClass() {
    if (currentAula!.hasMaterial && !isToShowMaterial) {
      _isToShowMaterialComplementar(true);
    } else {
      // verificar se a aula foi concluida
      if (currentAula!.status == AulaStatus.emAndamento) {
        _showDialogConfirmConcludeClass();
      } else {
        // caso nao, mostrar dialog
        // caso sim, fazer transicao
        debugPrint(
          'Definindo aula atual para: Aula${_aulas[_currentAulaIndex.value + 1].ordem}',
        );
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
        Get.back();
      },
    );
  }

  Future<void> initializeVideoPlayer() async {
    VideoPlayerController videoPlayerController;
    videoPlayerController = VideoPlayerController.networkUrl(
      Uri.parse(_currentAula.value!.urlVideo),
    );
    await videoPlayerController.initialize();
    final chewieController = ChewieController(
      videoPlayerController: videoPlayerController,
      showControlsOnInitialize: false,
      placeholder: Container(width: 50, height: 50, color: Colors.black),
      autoPlay: false,
      looping: false,
      deviceOrientationsAfterFullScreen: [DeviceOrientation.portraitUp],
    );
    _chewieController.value = chewieController;
  }

  Future<void> visualizeAula() async {
    _isVisulizeAulaLoading(true);
    await Future.delayed(const Duration(seconds: 2));
    final result = await _aulasService.concludeAula(aulaId: currentAula!.id);
    if (result) {
      _isVisulizeAulaLoading(false);
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
              isCurrent: currentAula!.ordem == aula.ordem,
            ),
          ),
        ),
      );
    }).toList();
  }
}
