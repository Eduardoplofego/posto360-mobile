import 'package:get/get.dart';
import 'package:posto360/modules/equipe/domain/repositories/equipe_repository.dart';
import 'package:posto360/modules/equipe/infra/repositories/equipe_repository_impl.dart';
import 'package:posto360/modules/equipe/infra/services/equipe_service.dart';
import 'package:posto360/modules/equipe/services/equipe_service_impl.dart';
import './equipe_controller.dart';

class EquipeBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EquipeRepository>(
      () => EquipeRepositoryImpl(postoRestClient: Get.find()),
    );
    Get.lazyPut<EquipeService>(
      () => EquipeServiceImpl(equipeRepository: Get.find()),
    );
    Get.put(EquipeController(equipeService: Get.find()));
  }
}
