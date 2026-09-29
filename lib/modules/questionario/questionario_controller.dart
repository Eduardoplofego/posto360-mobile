import 'package:get/get.dart';
import 'package:posto360/modules/core/domain/mixins/loader_mixin.dart';
import 'package:posto360/modules/core/domain/mixins/message_mixin.dart';
import 'package:posto360/modules/core/domain/services/auth_service.dart';
import 'package:posto360/modules/questionario/domain/models/questao_model.dart';
import 'package:posto360/modules/questionario/domain/models/questionario_model.dart';
import 'package:posto360/modules/questionario/infra/services/questionario_service.dart';

class QuestionarioController extends GetxController
    with LoaderMixin, MessageMixin {
  final QuestionarioService _questionarioService;
  final AuthService _authService;

  QuestionarioController({
    required QuestionarioService questionarioService,
    required AuthService authService,
  }) : _questionarioService = questionarioService,
       _authService = authService;

  // Observables
  final _loading = false.obs;
  final _message = Rxn<MessagesModel>();
  final _cursoId = 0.obs;
  final _cursoTitulo = ''.obs;
  final _questionario = Rxn<QuestionarioModel>();
  final _respostasSelecionadas = <int, int>{}.obs;
  final _enviando = false.obs;

  // Getters
  bool get isLoading => _loading.value;
  bool get isEnviando => _enviando.value;
  String get cursoTitulo => _cursoTitulo.value;
  QuestionarioModel? get questionario => _questionario.value;
  bool get liberado => questionario?.liberado ?? false;
  bool get aprovado => questionario?.aprovado ?? false;
  String? get motivoBloqueio => questionario?.motivo;
  int get aulasPendentes => questionario?.aulasPendentes ?? 0;
  num get notaMinima => questionario?.notaMinima ?? 0;
  num? get notaAtual => questionario?.notaAtual;
  int get rodadaAtual => questionario?.rodada ?? 1;
  List<QuestaoModel> get questoes => questionario?.questoes ?? [];
  List<QuestaoModel> get questoesPendentes =>
      questoes.where((q) => !q.bloqueada).toList();

  int? alternativaSelecionada(int questaoId) =>
      _respostasSelecionadas[questaoId];

  bool get podeEnviar =>
      questoesPendentes.isNotEmpty &&
      questoesPendentes.every((q) => _respostasSelecionadas.containsKey(q.id));

  // Actions
  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
    _lerArgumentosRota();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await carregarQuestionario();
  }

  void _lerArgumentosRota() {
    final params = Get.parameters;
    _cursoId.value = int.tryParse(params['cursoId'] ?? '') ?? 0;
    _cursoTitulo.value = params['cursoTitulo'] ?? '';
  }

  Future<void> carregarQuestionario() async {
    final usuario = _authService.authenticatedUser;
    if (usuario == null || _cursoId.value == 0) return;

    _loading(true);
    final result = await _questionarioService.getQuestionario(
      usuarioId: usuario.id,
      cursoId: _cursoId.value,
    );

    if (result.success && result.data != null) {
      _questionario.value = result.data;
      _preencherRespostasAnteriores();
    } else {
      _message(
        MessagesModel(
          title: 'Erro',
          message:
              result.message.isNotEmpty
                  ? result.message
                  : 'Não foi possível carregar a prova',
          type: MessageType.error,
        ),
      );
    }
    _loading(false);
  }

  // pré-seleciona a alternativa que o usuário marcou por último em questões
  // ainda erradas, para ele ver o que respondeu antes de trocar
  void _preencherRespostasAnteriores() {
    _respostasSelecionadas.clear();
    for (final questao in questoes) {
      if (!questao.bloqueada && questao.alternativaMarcadaId != null) {
        _respostasSelecionadas[questao.id] = questao.alternativaMarcadaId!;
      }
    }
  }

  void selecionarAlternativa(QuestaoModel questao, int alternativaId) {
    if (questao.bloqueada) return;
    _respostasSelecionadas[questao.id] = alternativaId;
  }

  Future<void> enviarRespostas() async {
    final usuario = _authService.authenticatedUser;
    if (usuario == null || !podeEnviar || isEnviando) return;

    _enviando(true);

    final respostas = <int, int>{
      for (final questao in questoesPendentes)
        questao.id: _respostasSelecionadas[questao.id]!,
    };

    final result = await _questionarioService.responderQuestionario(
      usuarioId: usuario.id,
      cursoId: _cursoId.value,
      respostas: respostas,
    );

    if (!result.success || result.data == null) {
      _enviando(false);
      _message(
        MessagesModel(
          title: 'Erro',
          message:
              result.message.isNotEmpty
                  ? result.message
                  : 'Não foi possível enviar as respostas',
          type: MessageType.error,
        ),
      );
      return;
    }

    final correcao = result.data!;
    _message(
      MessagesModel(
        title: correcao.aprovado ? 'Aprovado!' : 'Rodada corrigida',
        message:
            correcao.aprovado
                ? 'Nota final: ${correcao.nota.toStringAsFixed(0)}'
                : 'Nota: ${correcao.nota.toStringAsFixed(0)} (mínimo ${correcao.notaMinima.toStringAsFixed(0)}). Corrija as questões erradas e envie novamente.',
        type: correcao.aprovado ? MessageType.info : MessageType.error,
      ),
    );

    // recarrega do servidor: reflete os bloqueios e o estado mais atual
    await carregarQuestionario();
    _enviando(false);
  }

  void voltarParaAulas() {
    Get.back();
  }
}
