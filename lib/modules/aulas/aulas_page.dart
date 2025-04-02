import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';
import 'package:posto360/core/ui/widgets/custom_app_bar.dart';
import 'package:posto360/core/ui/widgets/icon_buttons/back_icon_button_widget.dart';
import 'package:posto360/modules/aulas/aulas_controller.dart';
import 'package:posto360/modules/aulas/widgets/module_progress.dart';
import 'package:posto360/modules/aulas/widgets/select_prev_next_class.dart';
import 'package:posto360/modules/aulas/widgets/video_player_widget.dart';
import 'package:posto360/modules/cursos/dtos/curso_to_aula_dto.dart';

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
    final dto = Get.arguments as CursoToAulaDTO;
    _controller.getCursoArgument(dto);
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: Obx(() {
          return CustomAppBar(
            title: _controller.curso?.titulo ?? '',
            leading: BackIconButtonWidget(
              onPressed: () async {
                Get.back();
              },
            ),
            withRoundedBorders: false,
          );
        }),
      ),
      backgroundColor: PostoAppUiConfigurations.lightPurpleColor,
      body: Obx(() {
        return ListView(
          children: [
            VideoPlayerWidget(),
            SelectPrevNextClass(
              prevClass: _controller.hasPrevClass ? null : () {},
              nextClass: _controller.hasNextClass ? null : () {},
            ),
            ModuleProgress(),
            ..._controller.generateTimeLineItems(),
          ],
        );
      }),
    );
  }
}
