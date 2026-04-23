import 'package:get/get.dart';
import 'package:posto360/modules/avaliacoes/domain/repositories/avaliacoes_module_repository.dart';
import 'package:posto360/modules/avaliacoes/infra/repositories/avaliacoes_repository_impl.dart';
import 'package:posto360/modules/avaliacoes/infra/services/avaliacoes_module_service.dart';
import 'package:posto360/modules/avaliacoes/services/avaliacoes_service_impl.dart';

class RealizarAvaliacaoBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AvaliacoesModuleRepository>(
      () => AvaliacoesModuleRepositoryImpl(Get.find()),
    );
    Get.lazyPut<AvaliacoesModuleService>(
      () => AvaliacoesModuleServiceImpl(Get.find()),
    );
    Get.put(RealizarAvaliacaoBindings());
  }
}
