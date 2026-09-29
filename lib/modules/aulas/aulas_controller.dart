import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/core/domain/mixins/loader_mixin.dart';
import 'package:posto360/modules/core/domain/mixins/message_mixin.dart';
import 'package:posto360/modules/core/domain/services/auth_service.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/core/domain/utils/enums/aula_status.dart';
import 'package:posto360/modules/aulas/domain/models/aula_model.dart';
import 'package:posto360/modules/aulas/domain/models/curso_model.dart';
import 'package:posto360/modules/aulas/widgets/timeline_certificado_item_widget.dart';
import 'package:posto360/modules/aulas/widgets/timeline_classes_widget.dart';
import 'package:posto360/modules/cursos/domain/dtos/curso_to_aula_dto.dart';
import 'package:posto360/modules/aulas/infra/services/aulas_service.dart';
import 'package:posto360/modules/aulas/widgets/timeline_quiz_item_widget.dart';
import 'package:posto360/modules/cursos/cursos_controller.dart';
import 'package:posto360/modules/questionario/infra/services/questionario_service.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class AulasController extends GetxController with LoaderMixin, MessageMixin {
  final AulasService _aulasService;
  final AuthService _authService;
  final QuestionarioService _questionarioService;

  AulasController({
    required AulasService aulasService,
    required AuthService authService,
    required QuestionarioService questionarioService,
  }) : _aulasService = aulasService,
       _authService = authService,
       _questionarioService = questionarioService;

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
  final _youtubeController = Rxn<YoutubePlayerController>();
  // ids das aulas cujo video ja recebeu play nesta sessao - so pode marcar
  // como assistida quem deu play (pedido do cliente)
  final _aulasComVideoReproduzido = <int>{}.obs;
  // prova entra como ultimo item da timeline (design doc, secao 7.4)
  final _existeQuestionario = false.obs;
  final _questionarioAprovado = false.obs;

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
  bool get existeQuestionario => _existeQuestionario.value;
  bool get questionarioAprovado => _questionarioAprovado.value;

  /// O certificado só existe depois que o backend o gera ao final do curso:
  /// usar isso como gatilho evita mostrar o item da timeline para cursos
  /// ainda em andamento.
  bool get temCertificado => _curso.value?.certificado.emitido ?? false;

  bool get hasNextClass {
    if (!hasData || _aulas.isEmpty) return false;

    final currentIndex = _currentAulaIndex.value;

    if (currentIndex < 0 || currentIndex >= _aulas.length) return false;

    final hasMaterial = _aulas[currentIndex].hasMaterial;

    final nextIndex = currentIndex + 1;
    final hasNextAulaDesbloqueada =
        nextIndex < _aulas.length &&
        _aulas[nextIndex].status != AulaStatus.bloqueado;

    final isUltimaAula = nextIndex >= _aulas.length;
    final aulaAtualFinalizada =
        _aulas[currentIndex].status == AulaStatus.finalizado;
    final podeAbrirProva =
        isUltimaAula &&
        aulaAtualFinalizada &&
        existeQuestionario &&
        !questionarioAprovado;

    return hasMaterial || hasNextAulaDesbloqueada || podeAbrirProva;
  }

  bool get pdfLoaded => _pdfLoaded.value;
  bool get isVisulizeAulaLoading => _isVisulizeAulaLoading.value;
  bool get videoInitialized => _youtubeController.value != null;
  YoutubePlayerController? get youtubeController => _youtubeController.value;
  bool get videoAtualFoiReproduzido {
    final aula = currentAula;
    if (aula == null) return false;
    return _aulasComVideoReproduzido.contains(aula.id);
  }

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
      await _loadQuestionarioStatus();
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

  Future<void> _loadQuestionarioStatus() async {
    final curso = _curso.value;
    final usuario = _authService.authenticatedUser;
    if (curso == null || usuario == null) return;

    final result = await _questionarioService.getQuestionario(
      usuarioId: usuario.id,
      cursoId: curso.templateId,
    );

    if (result.success && result.data != null) {
      _existeQuestionario.value = result.data!.existeProva;
      _questionarioAprovado.value = result.data!.aprovado;
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
      return;
    }

    // verificar se a aula foi concluida
    if (aula.status == AulaStatus.emAndamento) {
      _showDialogConfirmConcludeClass();
      return;
    }

    _isToShowMaterialComplementar(false);

    final isUltimaAula = currentAulaIndex + 1 >= _aulas.length;
    if (isUltimaAula && existeQuestionario && !questionarioAprovado) {
      abrirQuestionario();
      return;
    }

    setCurrentAula(currentAulaIndex + 1);
  }

  // a prova entra como ultimo item do caminho, depois da ultima aula
  // finalizada (design doc, secao 7.4)
  Future<void> abrirQuestionario() async {
    final cursoAtual = curso;
    if (cursoAtual == null) return;

    await Get.toNamed(
      '/cursos/questionario',
      parameters: {
        'cursoId': cursoAtual.templateId.toString(),
        'cursoTitulo': cursoAtual.titulo,
      },
    );

    // a prova pode ter sido aprovada (ou a rodada pode ter mudado) na tela
    // que acabou de fechar: recarrega aulas + status da prova aqui, e a
    // lista de cursos (o status do curso muda no servidor no mesmo instante
    // em que a prova e aprovada - design doc, secao 7.5)
    await _loadAulas();
    if (Get.isRegistered<CursosController>()) {
      await Get.find<CursosController>().onRefresh();
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

  // as aulas agora hospedam o video no YouTube (nao listado) em vez de um
  // arquivo no Supabase Storage, entao urlVideo e um link do YouTube (ou
  // apenas o id do video) em vez de uma url de video direta
  Future<void> initializeVideoPlayer() async {
    await _disposeVideoPlayer();

    final urlVideo = _currentAula.value?.urlVideo ?? '';
    if (urlVideo.isEmpty) return;

    final videoId = YoutubePlayer.convertUrlToId(urlVideo) ?? urlVideo;
    if (videoId.isEmpty) {
      log('Link de vídeo inválido para a aula ${_currentAula.value?.id}: $urlVideo');
      return;
    }

    try {
      _youtubeController.value = YoutubePlayerController(
        initialVideoId: videoId,
        flags: const YoutubePlayerFlags(
          autoPlay: false,
          mute: false,
          disableDragSeek: false,
        ),
      );
      _youtubeController.value!.addListener(_onYoutubePlayerStateChange);
    } catch (e, s) {
      // Um vídeo indisponível não pode impedir o acesso ao restante do curso.
      log('Erro ao inicializar o vídeo da aula', error: e, stackTrace: s);
      _youtubeController.value = null;
    }
  }

  // so pode marcar a aula como assistida quem deu play no video - assim que
  // o player entra em reprodução pela 1a vez, libera o botao para esta aula
  void _onYoutubePlayerStateChange() {
    final aula = _currentAula.value;
    final estado = _youtubeController.value?.value.playerState;
    if (aula != null && estado == PlayerState.playing) {
      _aulasComVideoReproduzido.add(aula.id);
    }
  }

  Future<void> _disposeVideoPlayer() async {
    final youtube = _youtubeController.value;
    if (youtube == null) return;
    youtube.removeListener(_onYoutubePlayerStateChange);
    // pausa antes de descartar para garantir que o video pare de tocar na
    // hora - o widget tambem troca de key ao mudar de aula, mas isso aqui
    // evita qualquer instante em que o video antigo continue rodando
    youtube.pause();
    _youtubeController.value = null;
    youtube.dispose();
  }

  Future<void> visualizeAula() async {
    final aula = currentAula;
    if (aula == null) return;

    if (!videoAtualFoiReproduzido) {
      _message(
        MessagesModel(
          title: 'Atenção',
          message: 'Assista ao vídeo antes de marcar a aula como assistida',
          type: MessageType.info,
        ),
      );
      return;
    }

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
    final items =
        _aulas.map((aula) {
          return SizedBox(
            height: 300,
            child: TimelineTile(
              isFirst: aula.ordem == 1,
              isLast:
                  aula.ordem == _aulas.last.ordem &&
                  !existeQuestionario &&
                  !temCertificado,
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

    if (existeQuestionario) {
      final todasAulasFinalizadas = _aulas.every(
        (aula) => aula.status == AulaStatus.finalizado,
      );
      items.add(
        SizedBox(
          height: 300,
          child: TimelineTile(
            isFirst: false,
            isLast: !temCertificado,
            alignment: TimelineAlign.center,
            indicatorStyle: IndicatorStyle(
              height: 230,
              width: Get.width,
              // tocavel assim que as aulas terminam: responde a prova se
              // ainda nao foi aprovada, ou so mostra a prova ja respondida
              // (mesma tela, o Obx de QuestionarioPage escolhe a build certa
              // pelo status vindo do servidor)
              indicator: GestureDetector(
                onTap: todasAulasFinalizadas ? abrirQuestionario : null,
                child: TimelineQuizItemWidget(
                  bloqueada: !todasAulasFinalizadas,
                  aprovado: questionarioAprovado,
                ),
              ),
            ),
          ),
        ),
      );
    }

    if (temCertificado) {
      final curso = _curso.value!;
      items.add(
        SizedBox(
          height: 340,
          child: TimelineTile(
            isFirst: false,
            isLast: true,
            alignment: TimelineAlign.center,
            indicatorStyle: IndicatorStyle(
              height: 280,
              width: Get.width,
              indicator: TimelineCertificadoItemWidget(
                certificado: curso.certificado,
                validade: curso.validadeConclusao,
              ),
            ),
          ),
        ),
      );
    }

    return items;
  }
}
