import 'package:posto360/models/horario_faltas_model.dart';

abstract class HorarioFaltasAtrasosRepository {
  Future<HorarioFaltasModel> getHorario({
    required String data,
    required String codigoFuncionario,
  });
}
