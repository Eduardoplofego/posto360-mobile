import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/registro_pontos/domain/models/faltas_atrasos_model.dart';
import 'package:posto360/modules/registro_pontos/domain/models/pontos_model.dart';
import 'package:posto360/modules/registro_pontos/domain/repositories/registro_pontos_repository.dart';
import '../infra/services/registro_pontos_services.dart';

class RegistroPontosServicesImpl extends RegistroPontosServices {
  final RegistroPontosRepository _repository;

  RegistroPontosServicesImpl(this._repository);

  @override
  Future<ResultActionDTO<List<PontosModel>>> getAllRegisters({
    required String usuarioId,
    required DateTime monthSelected,
  }) async {
    final dataInicial =
        '${monthSelected.year}-${monthSelected.month.toString().padLeft(2, '0')}-01';
    final lastDayMonth =
        DateTime(
          monthSelected.year,
          monthSelected.month + 1,
          1,
        ).subtract(Duration(days: 1)).day;
    final dataFinal =
        '${monthSelected.year}-${monthSelected.month.toString().padLeft(2, '0')}-${lastDayMonth.toString().padLeft(2, '0')}';
    return await _repository.getAllRegisters(
      usuarioId: usuarioId,
      dataInicial: dataInicial,
      dataFinal: dataFinal,
    );
  }

  @override
  Future<ResultActionDTO<FaltasAtrasosModel>> getFaltasAtrasos({
    required int codigoFuncionario,
    required DateTime monthSelected,
  }) async {
    final dataAtual =
        '${monthSelected.year}-${monthSelected.month.toString().padLeft(2, '0')}-${monthSelected.day.toString().padLeft(2, '0')}';
    final dataInicial =
        '${monthSelected.year}-${monthSelected.month.toString().padLeft(2, '0')}-01';
    final lastDayMonth =
        DateTime(
          monthSelected.year,
          monthSelected.month + 1,
          1,
        ).subtract(Duration(days: 1)).day;
    final dataFinal =
        '${monthSelected.year}-${monthSelected.month.toString().padLeft(2, '0')}-${lastDayMonth.toString().padLeft(2, '0')}';
    return await _repository.getFaltasAtrasos(
      dataInicial: dataInicial,
      dataFinal: dataFinal,
      dataAtual: dataAtual,
      codigoFuncionario: codigoFuncionario,
    );
  }
}
