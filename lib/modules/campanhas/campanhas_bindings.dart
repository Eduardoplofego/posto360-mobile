import 'package:get/get.dart';
import 'package:posto360/repositories/campanhas/campanhas_repository.dart';
import 'package:posto360/repositories/campanhas/campanhas_repository_impl.dart';
import 'package:posto360/repositories/performance/performance_repository.dart';
import 'package:posto360/repositories/performance/performance_repository_impl.dart';
import 'package:posto360/services/campanhas/campanhas_service.dart';
import 'package:posto360/services/campanhas/campanhas_service_impl.dart';
import 'package:posto360/services/performance/performance_service.dart';
import 'package:posto360/services/performance/performance_service_impl.dart';
import './campanhas_controller.dart';

class CampanhasBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CampanhasRepository>(
      () => CampanhasRepositoryImpl(postoRestClient: Get.find()),
    );
    Get.lazyPut<CampanhasService>(
      () => CampanhasServiceImpl(campanhaRepository: Get.find()),
    );
    Get.lazyPut<PerformanceRepository>(
      () => PerformanceRepositoryImpl(restClient: Get.find()),
    );
    Get.lazyPut<PerformanceService>(
      () => PerformanceServiceImpl(performanceRepository: Get.find()),
    );
    Get.put(
      CampanhasController(
        campanhaService: Get.find(),
        authService: Get.find(),
        performanceService: Get.find(),
      ),
    );
  }
}
