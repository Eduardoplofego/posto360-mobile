import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:posto360/modules/avaliacoes/domain/models/avaliacoes_avaliador_model.dart';
import 'package:posto360/modules/avaliacoes/widgets/avaliacao_avaliador_card.dart';
import 'package:posto360/modules/avaliacoes/widgets/avaliacao_card.dart';
import 'package:posto360/modules/avaliacoes/widgets/tabbar_widget.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import '../controllers/avaliacoes_controller.dart';

class AvaliacoesPage extends GetView<AvaliacoesController> {
  const AvaliacoesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(130),
        child: AppBar(
          title: Text('Avaliações', style: TextStyle(color: Colors.white)),
          centerTitle: false,
          leading: IconButton(
            onPressed: () {
              Get.back(closeOverlays: true);
              ();
            },
            icon: Icon(Icons.arrow_back, color: Colors.white),
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/waves.png'),
                fit: BoxFit.fitWidth,
              ),
            ),
          ),
          backgroundColor: PostoAppUiConfigurations.blueMediumColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(18),
              bottomRight: Radius.circular(18),
            ),
          ),
          bottom: PreferredSize(
            preferredSize: Size.fromWidth(0),
            child: Obx(() {
              return TabbarWidget(
                isLeftSelected: controller.isAvaliadoSelected,
                onLeftSelected: controller.onLeftTabPressed,
                onRigthSelected: controller.onRightTabPressed,
              );
            }),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading) {
          return Center(
            child: CircularProgressIndicator(
              color: PostoAppUiConfigurations.blueMediumColor,
            ),
          );
        }
        switch (controller.isAvaliadoSelected) {
          case true:
            return avaliadoPage();
          default:
            return moduloAvaliadorPage();
        }
      }),
    );
  }

  Widget avaliadoPage() {
    return Column(
      spacing: 12,
      children: [
        const SizedBox(height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Obx(() {
            return Row(
              children: [
                RichText(
                  text: TextSpan(
                    text: controller.totalPendingAvaliations.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: PostoAppUiConfigurations.greyColor,
                    ),
                    children: [
                      TextSpan(
                        text: ' avaliações pendentes',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                          color: PostoAppUiConfigurations.greyColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                RichText(
                  text: TextSpan(
                    text: controller.totalAvaliationsConcluded.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: PostoAppUiConfigurations.greyColor,
                    ),
                    children: [
                      TextSpan(
                        text: ' concluídas',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                          color: PostoAppUiConfigurations.greyColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
        const Divider(height: 0),
        Expanded(
          child: RefreshIndicator(
            onRefresh: controller.loadList,
            backgroundColor: Colors.white,
            color: PostoAppUiConfigurations.blueMediumColor,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  height: constraints.maxHeight,
                  child: Obx(() {
                    if (controller.avaliationsList.isEmpty) {
                      return Center(
                        child: Text('Nenhuma avaliação encontrada'),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          final item = controller.avaliationsList[index];
                          return GestureDetector(
                            onTap: () {
                              Get.toNamed(
                                '/avaliacoes/detalhes/',
                                arguments: {
                                  'gestaoAvaliacaoId': item.id,
                                  'modeloAvaliacaoId': item.modeloId,
                                  'comentario': item.comentarios,
                                  'penalidade': item.penalidade,
                                },
                              );
                            },
                            child: AvaliacaoCard(model: item),
                          );
                        },
                        separatorBuilder:
                            (context, index) => const SizedBox(height: 12),
                        itemCount: controller.avaliationsList.length,
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget moduloAvaliadorPage() {
    return Column(
      spacing: 12,
      children: [
        const SizedBox(height: 1),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Obx(() {
            return Row(
              children: [
                RichText(
                  text: TextSpan(
                    text:
                        controller.totalAvaliacoesAvaliadorPendentes.toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: PostoAppUiConfigurations.greyColor,
                    ),
                    children: [
                      TextSpan(
                        text: ' avaliações pendentes',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                          color: PostoAppUiConfigurations.greyColor,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                RichText(
                  text: TextSpan(
                    text:
                        controller.totalAvaliacoesAvaliadorFinalizadas
                            .toString(),
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: PostoAppUiConfigurations.greyColor,
                    ),
                    children: [
                      TextSpan(
                        text: ' concluídas',
                        style: TextStyle(
                          fontWeight: FontWeight.normal,
                          fontSize: 15,
                          color: PostoAppUiConfigurations.greyColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          }),
        ),
        const Divider(height: 0),
        Expanded(
          child: RefreshIndicator(
            onRefresh: controller.loadAvaliacoesAvaliador,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return SizedBox(
                  height: constraints.maxHeight,
                  child: Obx(() {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ListView.separated(
                        itemBuilder: (context, index) {
                          final item =
                              controller.avaliadorAvaliacoes[index]
                                  as AvaliacaoPendente;
                          return AvaliacaoAvaliadorCard(
                            model: item,
                            onPressed: controller.navigateToDiscretionsPage,
                          );
                        },
                        separatorBuilder:
                            (context, index) => const SizedBox(height: 12),
                        itemCount: controller.avaliadorAvaliacoes.length,
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
