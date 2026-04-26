import 'package:get/get.dart';
import 'package:posto360/modules/dash/domain/repositories/fechamento_caixa_repository.dart';
import 'package:posto360/modules/dash/domain/repositories/horario_faltas_atrasos_repository.dart';
import 'package:posto360/modules/dash/infra/repositories/fechamento_caixa_repository_impl.dart';
import 'package:posto360/modules/dash/infra/repositories/horario_faltas_atrasos_repository_impl.dart';
import 'package:posto360/modules/dash/infra/services/fechamento_caixa_service.dart';
import 'package:posto360/modules/dash/infra/services/horario_faltas_atrasos_service.dart';
import 'package:posto360/modules/dash/services/fechamento_caixa_service_impl.dart';
import 'package:posto360/modules/dash/services/horario_faltas_atrasos_service_impl.dart';
import 'package:posto360/modules/equipe/domain/repositories/equipe_repository.dart';
import 'package:posto360/modules/equipe/infra/repositories/equipe_repository_impl.dart';
import 'package:posto360/modules/equipe/infra/services/equipe_service.dart';
import 'package:posto360/modules/equipe/services/equipe_service_impl.dart';
import './colaborador_detalhe_controller.dart';

class ColaboradorDetalheBindings implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EquipeRepository>(
      () => EquipeRepositoryImpl(postoRestClient: Get.find()),
    );
    Get.lazyPut<EquipeService>(
      () => EquipeServiceImpl(equipeRepository: Get.find()),
    );
    Get.lazyPut<HorarioFaltasAtrasosRepository>(
      () => HorarioFaltasAtrasosRepositoryImpl(postoRestClient: Get.find()),
    );
    Get.lazyPut<HorarioFaltasAtrasosService>(
      () => HorarioFaltasAtrasosServiceImpl(
        horarioFaltasAtrasosRepository: Get.find(),
      ),
    );
    Get.lazyPut<FechamentoCaixaRepository>(
      () => FechamentoCaixaRepositoryImpl(postoRestClient: Get.find()),
    );
    Get.lazyPut<FechamentoCaixaService>(
      () => FechamentoCaixaServiceImpl(fechamentoCaixaRepository: Get.find()),
    );
    Get.put(
      ColaboradorDetalheController(
        equipeService: Get.find(),
        horarioService: Get.find(),
        fechamentoService: Get.find(),
      ),
    );
  }
}
