import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:posto360/core/ui/posto_app_ui_configurations.dart';
import 'package:posto360/core/ui/widgets/custom_app_bar.dart';
import 'package:posto360/core/ui/widgets/icon_buttons/back_icon_button_widget.dart';
import 'package:posto360/modules/cursos/widgets/cursos_general_details.dart';
import 'package:posto360/modules/cursos/widgets/cursos_tab_item.dart';
import 'package:posto360/modules/cursos/widgets/custom_textform_field.dart';
import 'package:posto360/modules/cursos/widgets/tab_bar_cursos.dart';
import './cursos_controller.dart';

class CursosPage extends GetView<CursosController> {
  const CursosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: CustomAppBar(
          title: 'Cursos',
          leading: BackIconButtonWidget(
            onPressed: () async {
              Get.back();
            },
          ),
          actions: [],
        ),
      ),
      body: RefreshIndicator(
        onRefresh: controller.onRefresh,
        backgroundColor: Colors.white,
        color: PostoAppUiConfigurations.blueMediumColor,
        child: DefaultTabController(
          length: 2,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: [
                CustomTextformField(onChanged: controller.onSearchChanged),
                const SizedBox(height: 16),
                const CursosGeneralDetails(),
                const SizedBox(height: 24),
                const TabBarCursos(),
                const SizedBox(height: 24),
                const CursosTabItem(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
