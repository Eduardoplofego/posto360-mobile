import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/registro_pontos/domain/models/faltas_atrasos_model.dart';
import 'package:posto360/modules/registro_pontos/domain/models/penalidade_model.dart';
import 'package:posto360/modules/registro_pontos/domain/models/pontos_model.dart';

abstract class RegistroPontosServices {
  Future<ResultActionDTO<List<PontosModel>>> getAllRegisters({
    required String usuarioId,
    required DateTime monthSelected,
  });
  Future<ResultActionDTO<FaltasAtrasosModel>> getFaltasAtrasos({
    required int codigoFuncionario,
    required DateTime monthSelected,
  });
  Future<ResultActionDTO<List<PenalidadeModel>>> getPenalidades({
    required String usuarioId,
    required DateTime monthSelected,
  });
}
