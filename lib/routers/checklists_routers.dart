import 'package:get/get.dart';
import 'package:posto360/modules/checklist/checklist_bindings.dart';
import 'package:posto360/modules/checklist/checklist_page.dart';
import 'package:posto360/modules/checklist/checklist_answer_bindings.dart';
import 'package:posto360/modules/checklist/checklist_answer_page.dart';

class ChecklistsRouters {
  ChecklistsRouters._();

  static final routes = <GetPage>[
    GetPage(
      name: '/checklists',
      binding: ChecklistBindings(),
      page: () => const ChecklistPage(),
    ),
    GetPage(
      name: '/checklists/answers/',
      binding: ChecklistAnswerBindings(),
      page: () => const ChecklistAnswerPage(),
    ),
  ];
}
