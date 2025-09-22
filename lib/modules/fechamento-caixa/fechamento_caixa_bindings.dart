import 'package:get/get.dart';
import 'package:posto360/modules/fechamento-caixa/domain/repositories/fechamento_caixa_repository.dart';
import 'package:posto360/modules/fechamento-caixa/fechamento_caixa_controller.dart';
import 'package:posto360/modules/fechamento-caixa/infra/repositories/fechamento_caixa_repository_impl.dart';
import 'package:posto360/modules/fechamento-caixa/infra/services/fechamento_caixa_service.dart';
import 'package:posto360/modules/fechamento-caixa/services/fechamento_caixa_service_impl.dart';

class FechamentoCaixaBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<FechamentoCaixaRepository>(
      () => FechamentoCaixaRepositoryImpl(postoRestClient: Get.find()),
    );
    Get.lazyPut<FechamentoCaixaService>(
      () => FechamentoCaixaServiceImpl(fechamentoCaixaRepository: Get.find()),
    );
    Get.put(
      FechamentoCaixaController(
        fechamentoCaixaService: Get.find(),
        authService: Get.find(),
      ),
    );
  }
}
