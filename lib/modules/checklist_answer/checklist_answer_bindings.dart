import 'package:get/get.dart';
import './checklist_answer_controller.dart';

class ChecklistAnswerBindings implements Bindings {
  @override
  void dependencies() {
    Get.put(ChecklistAnswerController(checklistService: Get.find()));
  }
}
