import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/avaliacoes/avaliacoes_criterios_controller.dart';
import 'package:posto360/modules/avaliacoes/widgets/detalhes_avaliacao_header.dart';
import 'package:posto360/modules/avaliacoes/widgets/discretions_card.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/core/domain/ui/widgets/error_loading_widget.dart';

class AvaliacoesCriteriosPage extends GetView<AvaliacoesCriteriosController> {
  const AvaliacoesCriteriosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(90),
        child: AppBar(
          title: Text(
            'Detalhes da avaliação',
            style: TextStyle(color: Colors.white),
          ),
          leading: IconButton(
            onPressed: () {
              Get.back();
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
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16, left: 70),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Text(
                    'Avaliação de segurança',
                    style: TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      body: Obx(() {
        if (controller.hasError) {
          return ErrorLoadingWidget(
            title: 'Houve algum erro',
            message: controller.errorMessage!,
            reload: controller.loadData,
          );
        }
        return controller.isLoading
            ? Center(
              child: CircularProgressIndicator(
                color: PostoAppUiConfigurations.blueMediumColor,
              ),
            )
            : Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 1,
                        spreadRadius: 1,
                        offset: Offset(1, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      DetalhesAvaliacaoHeader(
                        totalDiscretions: controller.totalCriterios,
                        concludedDiscretions:
                            controller.totalCriteriosCumpridos,
                        penality: controller.penalidade,
                        comment: controller.comentario,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                if (controller.criterios.isEmpty)
                  Column(
                    children: [
                      const SizedBox(height: 12),
                      Center(child: Text('Nenhum critério encontrado')),
                    ],
                  ),
                if (controller.criterios.isNotEmpty)
                  Expanded(
                    child: LayoutBuilder(
                      builder: (context, constraints) {
                        return Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          height: constraints.maxHeight,
                          child: ListView.separated(
                            itemBuilder: (context, index) {
                              final item = controller.criterios[index];
                              return DiscretionsCard(model: item);
                            },
                            separatorBuilder:
                                (context, index) => const SizedBox(height: 12),
                            itemCount: controller.criterios.length,
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
      }),
    );
  }
}
