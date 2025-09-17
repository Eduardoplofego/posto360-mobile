import 'dart:developer';

import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/core/domain/rest_client/api_routes/api_routes.dart';
import 'package:posto360/modules/core/domain/rest_client/posto_rest_client.dart';

import '../../domain/repositories/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final PostoRestClient _postoRestClient;

  UserRepositoryImpl({required PostoRestClient postoRestClient})
    : _postoRestClient = postoRestClient;

  @override
  Future<ResultActionDTO<String>> sendProfilePhoto({
    required String userId,
    required Map<String, dynamic> image,
  }) async {
    try {
      final result = await _postoRestClient.post(ApiRoutes.subirFotoPerfil(), {
        "usuarioId": userId,
        "imagem": image,
      });
      final resultUrl = result.body['url'] as String?;

      if (resultUrl != null) {
        return ResultActionDTO.success(data: resultUrl);
      } else {
        return ResultActionDTO.failure('Não foi possível salvar a imagem', '');
      }
    } catch (e, s) {
      log('Erro subir imagem', error: e, stackTrace: s);
      return ResultActionDTO.failure('Não foi possível salvar a imagem', '');
    }
  }
}
