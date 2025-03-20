import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:posto360/core/exceptions/internal_server_exception.dart';
import 'package:posto360/core/exceptions/invalid_parameters_exception.dart';
import 'package:posto360/core/rest_client/api_routes/api_routes.dart';
import 'package:posto360/core/rest_client/posto_rest_client.dart';
import 'package:posto360/models/horario_faltas_model.dart';

import 'horario_faltas_atrasos_repository.dart';

class HorarioFaltasAtrasosRepositoryImpl
    extends HorarioFaltasAtrasosRepository {
  final PostoRestClient _restClient;

  HorarioFaltasAtrasosRepositoryImpl({required PostoRestClient postoRestClient})
    : _restClient = postoRestClient;

  @override
  Future<HorarioFaltasModel> getHorario({
    required String data,
    required String codigoFuncionario,
  }) async {
    try {
      final result = await _restClient.post(ApiRoutes.honorario(), {
        'data': data,
        'funcionarioCodigo': codigoFuncionario,
      });
      return HorarioFaltasModel.fromMap(result.body);
    } on DioException catch (e, s) {
      log('Erro get HorarioFaltasModel', error: e, stackTrace: s);
      if (e.response?.statusCode == 400) {
        throw InvalidParametersException();
      }
      throw InternalServerException();
    } catch (_) {
      throw InternalServerException();
    }
  }
}
