import 'package:get/get.dart';
import 'package:posto360/modules/cursos/domain/repositories/cursos_repository.dart';
import 'package:posto360/modules/cursos/infra/repositories/cursos_repository_impl.dart';
import 'package:posto360/modules/dash/domain/repositories/campanhas_repository.dart';
import 'package:posto360/modules/dash/domain/repositories/dashboard_repository.dart';
import 'package:posto360/modules/dash/infra/repositories/campanhas_repository_impl.dart';
import 'package:posto360/modules/dash/infra/repositories/dashboard_repository_impl.dart';
import 'package:posto360/modules/dash/domain/repositories/horario_faltas_atrasos_repository.dart';
import 'package:posto360/modules/dash/infra/repositories/horario_faltas_atrasos_repository_impl.dart';
import 'package:posto360/modules/campanhas/domain/repositories/performance_repository.dart';
import 'package:posto360/modules/campanhas/infra/repositories/performance_repository_impl.dart';
import 'package:posto360/modules/core/domain/repositories/user_repository.dart';
import 'package:posto360/modules/core/infra/repositories/user_repository_impl.dart';
import 'package:posto360/modules/cursos/infra/services/cursos_service.dart';
import 'package:posto360/modules/cursos/services/cursos_service_impl.dart';
import 'package:posto360/modules/dash/infra/services/campanhas_service.dart';
import 'package:posto360/modules/dash/infra/services/dashboard_service.dart';
import 'package:posto360/modules/dash/services/campanhas_service_impl.dart';
import 'package:posto360/modules/dash/services/dashboard_service_impl.dart';
import 'package:posto360/modules/dash/infra/services/horario_faltas_atrasos_service.dart';
import 'package:posto360/modules/dash/services/horario_faltas_atrasos_service_impl.dart';
import 'package:posto360/modules/campanhas/infra/services/performance_service.dart';
import 'package:posto360/modules/campanhas/services/performance_service_impl.dart';
import 'package:posto360/modules/core/infra/services/user_service.dart';
import 'package:posto360/modules/core/services/user_service_impl.dart';
import 'package:posto360/modules/fechamento-caixa/domain/repositories/fechamento_caixa_repository.dart';
import 'package:posto360/modules/fechamento-caixa/infra/repositories/fechamento_caixa_repository_impl.dart';
import 'package:posto360/modules/fechamento-caixa/infra/services/fechamento_caixa_service.dart';
import 'package:posto360/modules/fechamento-caixa/services/fechamento_caixa_service_impl.dart';
import 'dash_controller.dart';

class DashBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UserRepository>(
      () => UserRepositoryImpl(postoRestClient: Get.find()),
    );
    Get.lazyPut<UserService>(() => UserServiceImpl(userRepository: Get.find()));
    Get.lazyPut<HorarioFaltasAtrasosRepository>(
      () => HorarioFaltasAtrasosRepositoryImpl(postoRestClient: Get.find()),
    );
    Get.lazyPut<HorarioFaltasAtrasosService>(
      () => HorarioFaltasAtrasosServiceImpl(
        horarioFaltasAtrasosRepository: Get.find(),
      ),
    );
    Get.lazyPut<CampanhasRepository>(
      () => CampanhasRepositoryImpl(postoRestClient: Get.find()),
    );
    Get.lazyPut<CampanhasService>(
      () => CampanhasServiceImpl(campanhaRepository: Get.find()),
    );
    Get.lazyPut<CursosRepository>(
      () => CursosRepositoryImpl(postoRestClient: Get.find()),
    );
    Get.lazyPut<CursosService>(
      () => CursosServiceImpl(cursoRepository: Get.find()),
    );
    Get.lazyPut<PerformanceRepository>(
      () => PerformanceRepositoryImpl(restClient: Get.find()),
    );
    Get.lazyPut<PerformanceService>(
      () => PerformanceServiceImpl(performanceRepository: Get.find()),
    );
    Get.lazyPut<DashboardRepository>(
      () => DashboardRepositoryImpl(restClient: Get.find()),
    );
    Get.lazyPut<DashboardService>(
      () => DashboardServiceImpl(
        dashboardRepository: Get.find(),
        performanceService: Get.find(),
      ),
    );
    Get.lazyPut<FechamentoCaixaRepository>(
      () => FechamentoCaixaRepositoryImpl(postoRestClient: Get.find()),
    );
    Get.lazyPut<FechamentoCaixaService>(
      () => FechamentoCaixaServiceImpl(fechamentoCaixaRepository: Get.find()),
    );
    Get.put(DashController());
  }
}
