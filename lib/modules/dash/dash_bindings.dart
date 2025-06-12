import 'package:get/get.dart';
import 'package:posto360/repositories/campanhas/campanhas_repository.dart';
import 'package:posto360/repositories/campanhas/campanhas_repository_impl.dart';
import 'package:posto360/repositories/cursos/cursos_repository.dart';
import 'package:posto360/repositories/cursos/cursos_repository_impl.dart';
import 'package:posto360/repositories/dashboard/dashboard_repository.dart';
import 'package:posto360/repositories/dashboard/dashboard_repository_impl.dart';
import 'package:posto360/repositories/horario_faltas_atrasos/horario_faltas_atrasos_repository.dart';
import 'package:posto360/repositories/horario_faltas_atrasos/horario_faltas_atrasos_repository_impl.dart';
import 'package:posto360/repositories/performance/performance_repository.dart';
import 'package:posto360/repositories/performance/performance_repository_impl.dart';
import 'package:posto360/repositories/user/user_repository.dart';
import 'package:posto360/repositories/user/user_repository_impl.dart';
import 'package:posto360/services/campanhas/campanhas_service.dart';
import 'package:posto360/services/campanhas/campanhas_service_impl.dart';
import 'package:posto360/services/cursos/cursos_service.dart';
import 'package:posto360/services/cursos/cursos_service_impl.dart';
import 'package:posto360/services/dashboard/dashboard_service.dart';
import 'package:posto360/services/dashboard/dashboard_service_impl.dart';
import 'package:posto360/services/horario_faltas_atrasos/horario_faltas_atrasos_service.dart';
import 'package:posto360/services/horario_faltas_atrasos/horario_faltas_atrasos_service_impl.dart';
import 'package:posto360/services/performance/performance_service.dart';
import 'package:posto360/services/performance/performance_service_impl.dart';
import 'package:posto360/services/user/user_service.dart';
import 'package:posto360/services/user/user_service_impl.dart';
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
    Get.put(DashController());
  }
}
