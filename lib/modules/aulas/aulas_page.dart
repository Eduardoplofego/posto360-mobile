import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';
import 'package:posto360/modules/core/domain/ui/widgets/custom_app_bar.dart';
import 'package:posto360/modules/core/domain/ui/widgets/icon_buttons/back_icon_button_widget.dart';
import 'package:posto360/modules/aulas/aulas_controller.dart';
import 'package:posto360/modules/aulas/widgets/conclude_class_widget.dart';
import 'package:posto360/modules/cursos/widgets/curso_procedimentos_widget.dart';
import 'package:posto360/modules/aulas/widgets/module_progress.dart';
import 'package:posto360/modules/aulas/widgets/select_prev_next_class.dart';
import 'package:posto360/modules/aulas/widgets/video_player_widget.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class AulasPage extends StatefulWidget {
  const AulasPage({super.key});

  @override
  State<AulasPage> createState() => _AulasPageState();
}

class _AulasPageState extends State<AulasPage> {
  late AulasController _controller;

  @override
  void initState() {
    super.initState();
    _controller = Get.find<AulasController>();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: CustomAppBar.preferredSizeFor(),
        child: Obx(() {
          return CustomAppBar(
            title: _controller.curso?.titulo ?? '',
            leading: BackIconButtonWidget(
              onPressed: () {
                if (_controller.pdfLoaded) {
                  _controller.hideMaterialAulaWidget();
                } else {
                  Navigator.of(context).maybePop();
                }
              },
            ),
            withRoundedBorders: false,
          );
        }),
      ),
      backgroundColor: PostoAppUiConfigurations.lightPurpleColor,
      body: Obx(() {
        final urlMaterial = _controller.currentAula?.urlMaterial ?? '';
        if (_controller.pdfLoaded && urlMaterial.isNotEmpty) {
          return SfPdfViewer.network(urlMaterial);
        } else {
          return ListView(
            children: [
              VideoPlayerWidget(),
              SelectPrevNextClass(
                prevClass:
                    _controller.hasPrevClass ? _controller.setPrevClass : null,
                nextClass:
                    _controller.hasNextClass ? _controller.setNextClass : null,
              ),
              ConcludeClassWidget(),
              ModuleProgress(),
              CursoProcedimentosWidget(
                procedimentos: _controller.curso?.procedimentos ?? [],
              ),
              if (_controller.hasData) ..._controller.generateTimeLineItems(),
            ],
          );
        }
      }),
    );
  }
}
