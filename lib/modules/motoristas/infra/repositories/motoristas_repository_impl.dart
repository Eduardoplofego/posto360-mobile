import 'package:flutter/foundation.dart';
import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/core/domain/rest_client/api_routes/api_routes.dart';
import 'package:posto360/modules/core/domain/rest_client/posto_rest_client.dart';
import 'package:posto360/modules/motoristas/domain/models/dashboard_motorista_model.dart';
import 'package:posto360/modules/motoristas/domain/repositories/motoristas_repository.dart';

class MotoristasRepositoryImpl extends MotoristasRepository {
  final PostoRestClient _postoRestClient;

  MotoristasRepositoryImpl({required PostoRestClient postoRestClient})
      : _postoRestClient = postoRestClient;

  @override
  Future<ResultActionDTO<DashboardMotoristaModel>> getDashboard({
    required String motoristaId,
    required DateTime data,
  }) async {
    try {
      final dataStr =
          '${data.year.toString().padLeft(4, '0')}-${data.month.toString().padLeft(2, '0')}-${data.day.toString().padLeft(2, '0')}';

      final url = ApiRoutes.motoristasDashboard();
      final payload = {'motoristaId': motoristaId, 'data': dataStr};

      debugPrint('[motoristas-repo] POST $url body=$payload');

      final result = await _postoRestClient.post(url, payload);

      debugPrint(
        '[motoristas-repo] statusCode=${result.statusCode} statusText=${result.statusText} bodyType=${result.body.runtimeType}',
      );

      if (result.statusCode != null && result.statusCode! >= 400) {
        debugPrint('[motoristas-repo] body de erro: ${result.body}');
        return ResultActionDTO.failure(
          'Erro ao carregar dashboard (HTTP ${result.statusCode})',
          null,
        );
      }

      if (result.body == null) {
        debugPrint('[motoristas-repo] body null');
        return ResultActionDTO.failure(
          'Resposta vazia do servidor',
          null,
        );
      }

      final bodyStr = result.body.toString();
      debugPrint(
        '[motoristas-repo] body preview (${bodyStr.length} chars): ${bodyStr.substring(0, bodyStr.length > 500 ? 500 : bodyStr.length)}',
      );

      final dashboard = DashboardMotoristaModel.fromMap(
        Map<String, dynamic>.from(result.body),
      );
      debugPrint(
        '[motoristas-repo] parse ok: ${dashboard.filiais.length} filiais',
      );
      return ResultActionDTO.success(data: dashboard);
    } catch (e, s) {
      debugPrint('[motoristas-repo] EXCEPTION: $e');
      debugPrint('[motoristas-repo] stack: $s');
      return ResultActionDTO.failure(
        'Erro ao carregar dashboard do motorista: $e',
        null,
      );
    }
  }
}
