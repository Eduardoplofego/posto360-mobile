import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:posto360/modules/core/domain/ui/widgets/custom_app_bar.dart';
import 'package:posto360/modules/core/domain/ui/widgets/icon_buttons/back_icon_button_widget.dart';
import 'package:posto360/modules/checklist/widgets/general_checklist_widget.dart';
import 'package:posto360/modules/checklist/widgets/list_checklist_widget.dart';
import './checklist_controller.dart';

class ChecklistPage extends GetView<ChecklistController> {
  const ChecklistPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(70),
        child: CustomAppBar(
          title: 'Checklist',
          leading: BackIconButtonWidget(
            onPressed: () async {
              Get.back();
            },
          ),
          actions: [],
        ),
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          GeneralChecklistWidget(),
          const SizedBox(height: 8),
          Divider(),
          const SizedBox(height: 16),
          ListChecklistWidget(),
        ],
      ),
    );
  }
}
