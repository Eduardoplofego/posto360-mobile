import 'package:flick_video_player/flick_video_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/core/mixins/loader_mixin.dart';
import 'package:posto360/core/mixins/message_mixin.dart';
import 'package:posto360/core/services/auth_service.dart';
import 'package:posto360/core/utils/enums/aula_status.dart';
import 'package:posto360/models/aula_model.dart';
import 'package:posto360/models/curso_model.dart';
import 'package:posto360/modules/aulas/widgets/timeline_classes_widget.dart';
import 'package:posto360/modules/cursos/dtos/curso_to_aula_dto.dart';
import 'package:posto360/services/aulas/aulas_service.dart';
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

  final _message = Rxn<MessagesModel>();
  final _loading = false.obs;
  final _curso = Rxn<CursoModel>();
  final _aulas = <AulaModel>[].obs;
  final _currentAulaIndex = 0.obs;
  final _currentAula = Rxn<AulaModel>();
  final _flickManager = Rxn<FlickManager>();

  // Getters
  CursoModel? get curso => _curso.value;
  AulaModel? get currentAula => _currentAula.value;
  int get currentAulaIndex => _currentAulaIndex.value;
  bool get hasPrevClass => !(_currentAulaIndex.value != 0);
  bool get hasNextClass =>
      !(_currentAulaIndex.value != _aulas.length - 1 &&
          _currentAula.value != null);
  bool get videoInitialized => _flickManager.value != null;
  FlickManager? get flickManager => _flickManager.value;

  @override
  Future<void> onInit() async {
    super.onInit();
    messageListener(_message);
    loaderListener(_loading);
  }

  @override
  void onClose() {
    super.onClose();
    _flickManager.value?.dispose();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    _loading(true);
    if (curso != null) {
      await _loadAulas();
    }
    _loading(false);
  }

  Future<void> getCursoArgument(CursoToAulaDTO dto) async {
    _curso.value = dto.curso;
  }

  Future<void> _loadAulas() async {
    if (_curso.value != null) {
      final aulasDto = await _aulasService.getAulas(
        cursoId: _curso.value!.id,
        usuarioId: _authService.authenticatedUser!.id,
      );
      if (aulasDto.success) {
        final aulas = aulasDto.data!;
        aulas.sort((a, b) => a.ordem.compareTo(b.ordem));
        _aulas.assignAll(aulasDto.data!);
        _setCurrentAula();
      }
    }
  }

  void _setCurrentAula() {
    int current = 1;
    for (var aula in _aulas) {
      if (aula.status == AulaStatus.finalizado) {
        current++;
      }
    }
    _currentAulaIndex.value = current;
    _currentAula.value = _aulas.firstWhereOrNull(
      (aula) => aula.ordem == current,
    );
    if (_currentAula.value != null) {
      _flickManager.value = FlickManager(
        videoPlayerController: VideoPlayerController.networkUrl(
          Uri.parse(_currentAula.value!.urlVideo),
        ),
      );
    }
  }

  List<Widget> generateTimeLineItems() {
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
            indicator: TimelineClassItemWidget(aula: aula),
          ),
        ),
      );
    }).toList();
  }
}
