import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/core/domain/ui/widgets/custom_app_bar.dart';
import 'package:posto360/modules/core/domain/ui/widgets/icon_buttons/back_icon_button_widget.dart';
import 'package:posto360/modules/questionario/questionario_controller.dart';
import 'package:posto360/modules/questionario/widgets/footer_enviar_respostas.dart';
import 'package:posto360/modules/questionario/widgets/questao_card.dart';

class QuestionarioPage extends GetView<QuestionarioController> {
  const QuestionarioPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: CustomAppBar.preferredSizeFor(),
        child: Obx(
          () => CustomAppBar(
            title: controller.cursoTitulo.isNotEmpty
                ? controller.cursoTitulo
                : 'Prova final',
            leading: BackIconButtonWidget(onPressed: () => Get.back()),
            withRoundedBorders: false,
          ),
        ),
      ),
      backgroundColor: PostoAppUiConfigurations.lightPurpleColor,
      body: Obx(() {
        final questionario = controller.questionario;

        if (questionario == null) {
          return const SizedBox.shrink();
        }

        if (!controller.liberado) {
          return _buildTravada(context);
        }

        if (controller.aprovado) {
          return _buildAprovado(context);
        }

        return _buildRespondendo(context);
      }),
      // botao de acao fica fora do body, no slot proprio do Scaffold - assim
      // o Flutter ja poe ele acima da barra de gestos/navegacao do celular
      // (SafeArea) em vez de renderizar por baixo dela, como acontecia com
      // esse footer dentro do body (design doc nao previu isso, foi reportado
      // pelo cliente depois de testar)
      bottomNavigationBar: Obx(() {
        final questionario = controller.questionario;
        if (questionario == null || !controller.liberado) {
          return const SizedBox.shrink();
        }

        return SafeArea(
          top: false,
          child:
              controller.aprovado
                  ? _buildBotaoVoltar()
                  : FooterEnviarRespostas(
                    isActive: controller.podeEnviar && !controller.isEnviando,
                    onPressed: controller.enviarRespostas,
                  ),
        );
      }),
    );
  }

  Widget _buildBotaoVoltar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: controller.voltarParaAulas,
          style: ElevatedButton.styleFrom(
            backgroundColor: PostoAppUiConfigurations.blueMediumColor,
          ),
          child: const Text(
            'Voltar',
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ),
    );
  }

  Widget _buildTravada(BuildContext context) {
    final pendentes = controller.aulasPendentes;
    final semQuestionario = controller.motivoBloqueio == 'sem-questionario';

    final mensagem =
        semQuestionario
            ? 'Este curso não possui prova.'
            : pendentes > 0
            ? 'Termine as $pendentes aula${pendentes > 1 ? 's' : ''} restante${pendentes > 1 ? 's' : ''} para liberar a prova.'
            : 'Termine as aulas para liberar a prova.';

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.lock,
              size: 64,
              color: PostoAppUiConfigurations.greyColor,
            ),
            const SizedBox(height: 16),
            Text(
              mensagem,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: PostoAppUiConfigurations.textDarkColor,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // prova ja aprovada: mostra o cabecalho com a nota e, abaixo, a prova
  // inteira em modo leitura (mesmo QuestaoCard da tela de responder, so que
  // toda questao volta bloqueada=true do backend - fica so exibindo o que
  // foi marcado, sem deixar mexer). O gabarito nunca e exposto pelo backend,
  // entao uma eventual questao errada aqui so mostra a escolha errada, nunca
  // qual era a certa (design intencional - RespostasQuestionario nao guarda
  // isso).
  Widget _buildAprovado(BuildContext context) {
    final nota = controller.notaAtual;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
          child: Column(
            children: [
              Icon(
                Icons.emoji_events,
                size: 64,
                color: PostoAppUiConfigurations.blueMediumColor,
              ),
              const SizedBox(height: 12),
              Text(
                'Prova aprovada!',
                style: PostoAppUiConfigurations.textBold,
              ),
              if (nota != null) ...[
                const SizedBox(height: 4),
                Text(
                  'Nota final: ${nota.toStringAsFixed(0)}',
                  style: PostoAppUiConfigurations.textNormal,
                ),
              ],
            ],
          ),
        ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            itemCount: controller.questoes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final questao = controller.questoes[index];
              // IgnorePointer pra nao dar nem o feedback visual de toque -
              // sao os cards nao bloqueados (questao nunca acertada) que
              // ainda teriam onPressed ativo no AlternativaOption por baixo
              return IgnorePointer(
                child: QuestaoCard(
                  questao: questao,
                  alternativaSelecionada: questao.alternativaMarcadaId,
                  onSelecionar: (_) {},
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRespondendo(BuildContext context) {
    return Column(
      children: [
        if (controller.rodadaAtual > 1)
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'Rodada ${controller.rodadaAtual} — nota atual: '
              '${controller.notaAtual?.toStringAsFixed(0) ?? '-'} '
              '(mínimo ${controller.notaMinima.toStringAsFixed(0)})',
              style: TextStyle(color: PostoAppUiConfigurations.greyColor),
            ),
          ),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: controller.questoes.length,
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemBuilder: (context, index) {
              final questao = controller.questoes[index];
              return QuestaoCard(
                questao: questao,
                alternativaSelecionada: controller.alternativaSelecionada(
                  questao.id,
                ),
                onSelecionar:
                    (alternativaId) =>
                        controller.selecionarAlternativa(
                          questao,
                          alternativaId,
                        ),
              );
            },
          ),
        ),
      ],
    );
  }
}
