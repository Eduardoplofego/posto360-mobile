import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/avaliacoes/pages/controllers/realizar_avaliacao_controller.dart';
import 'package:posto360/modules/avaliacoes/widgets/avaliator_discretion_card.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';

class RealizarAvaliacaoPage extends GetView<RealizarAvaliacaoController> {
  const RealizarAvaliacaoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: AppBar(
          title: Text(
            'Realizar avaliação',
            style: TextStyle(color: Colors.white),
          ),
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
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    const SizedBox(width: 70),
                    Text(
                      'Avaliação de segurança',
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: IntrinsicHeight(
        child: Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          child: Column(
            children: [
              Obx(() {
                return SizedBox(
                  width: 250,
                  child: ElevatedButton(
                    onPressed:
                        controller.progress == 1
                            ? controller.concludeAvaliation
                            : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: PostoAppUiConfigurations.blueMediumColor,
                    ),
                    child: Text(
                      'Finalizar (${controller.discretionsConcluded}/${controller.totalDiscretions})',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                );
              }),
              const SizedBox(height: 6),
              Text(
                'Preencha todos os critérios para habilitar',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
      body: Obx(() {
        return Column(
          children: [
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: BoxDecoration(),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Progresso'),
                      Text(
                        '${controller.discretionsConcluded} de ${controller.totalDiscretions} critérios',
                        style: TextStyle(
                          color: PostoAppUiConfigurations.blueLightColor,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: controller.progress,
                    minHeight: 9,
                    borderRadius: BorderRadius.circular(12),
                    color: PostoAppUiConfigurations.blueLightColor,
                    backgroundColor: PostoAppUiConfigurations.lightPurpleColor,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SizedBox(
                      height: constraints.maxHeight,
                      child: ListView.separated(
                        itemCount: controller.totalDiscretions,
                        separatorBuilder:
                            (context, index) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final item = controller.discretionsList[index];
                          return Obx(() {
                            return GestureDetector(
                              onTap: () {
                                controller.setDiscretionSelected(index);
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 3,
                                ),
                                child: AvaliatorDiscretionCard(
                                  model: item,
                                  index: index,
                                  isLoading:
                                      controller.isConfirmingDiscretion &&
                                      index ==
                                          controller.discretionSelectedIndex,
                                  onConfirm:
                                      (value) =>
                                          controller.onConfirmDiscretion(value),
                                  isOpened:
                                      index ==
                                      controller.discretionSelectedIndex,
                                ),
                              ),
                            );
                          });
                        },
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
