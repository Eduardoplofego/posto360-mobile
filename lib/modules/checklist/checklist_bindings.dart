import 'package:get/get.dart';
import 'package:posto360/modules/checklist/domain/repositories/checklists_repository.dart';
import 'package:posto360/modules/checklist/infra/repositories/checklists_repository_impl.dart';
import 'package:posto360/modules/checklist/infra/services/checklist_service.dart';
import 'package:posto360/modules/checklist/services/checklist_service_impl.dart';
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
