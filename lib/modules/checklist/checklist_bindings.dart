import 'package:get/get.dart';
import 'package:posto360/repositories/checklists/checklists_repository.dart';
import 'package:posto360/repositories/checklists/checklists_repository_impl.dart';
import 'package:posto360/services/checklists/checklist_service.dart';
import 'package:posto360/services/checklists/checklist_service_impl.dart';
import './checklist_controller.dart';

class ChecklistBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ChecklistsRepository>(
      () => ChecklistsRepositoryImpl(postoRestClient: Get.find()),
    );
    Get.lazyPut<ChecklistService>(
      () => ChecklistServiceImpl(checklistRepository: Get.find()),
    );
    Get.put(ChecklistController(checklistService: Get.find()));
  }
}
