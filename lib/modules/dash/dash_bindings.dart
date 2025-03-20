import 'package:get/get.dart';
import 'package:posto360/repositories/horario_faltas_atrasos/horario_faltas_atrasos_repository.dart';
import 'package:posto360/repositories/horario_faltas_atrasos/horario_faltas_atrasos_repository_impl.dart';
import 'package:posto360/services/horario_faltas_atrasos/horario_faltas_atrasos_service.dart';
import 'package:posto360/services/horario_faltas_atrasos/horario_faltas_atrasos_service_impl.dart';
import 'dash_controller.dart';

class DashBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HorarioFaltasAtrasosRepository>(
      () => HorarioFaltasAtrasosRepositoryImpl(postoRestClient: Get.find()),
    );
    Get.lazyPut<HorarioFaltasAtrasosService>(
      () => HorarioFaltasAtrasosServiceImpl(
        horarioFaltasAtrasosRepository: Get.find(),
      ),
    );
    Get.put(DashController());
  }
}
