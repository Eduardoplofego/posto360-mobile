import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/registro_pontos/domain/models/faltas_atrasos_model.dart';
import 'package:posto360/modules/registro_pontos/domain/models/pontos_model.dart';

abstract class RegistroPontosRepository {
  Future<ResultActionDTO<List<PontosModel>>> getAllRegisters({
    required String usuarioId,
    required String dataInicial,
    required String dataFinal,
  });
  Future<ResultActionDTO<FaltasAtrasosModel>> getFaltasAtrasos({
    required String dataInicial,
    required String dataFinal,
    required String dataAtual,
    required int codigoFuncionario,
  });
}
