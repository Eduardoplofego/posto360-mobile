import 'package:posto360/models/horario_faltas_model.dart';

abstract class HorarioFaltasAtrasosService {
  Future<HorarioFaltasModel> getHorario({
    required String data,
    required String codigoFuncionario,
  });
}
