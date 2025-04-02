import 'dart:developer';

import 'package:posto360/core/dto/result_action_dto.dart';
import 'package:posto360/core/rest_client/api_routes/api_routes.dart';
import 'package:posto360/core/rest_client/posto_rest_client.dart';
import 'package:posto360/core/utils/enums/aula_status.dart';

import 'package:posto360/models/aula_model.dart';

import './aula_repository.dart';

class AulaRepositoryImpl extends AulaRepository {
  final PostoRestClient _restClient;

  AulaRepositoryImpl({required PostoRestClient restClient})
    : _restClient = restClient;

  final _aulas = <AulaModel>[
    AulaModel(
      id: 1,
      templateId: 2,
      titulo: 'Fundamentos da Liderança em Vendas',
      descricao: '',
      urlVideo:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      urlMaterial: '',
      capa: '',
      ordem: 1,
      status: AulaStatus.finalizado,
    ),
    AulaModel(
      id: 3,
      templateId: 2,
      titulo: 'Estratégias de Vendas e Negociação para Líderes',
      descricao: '',
      urlVideo:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      urlMaterial: '',
      capa: '',
      ordem: 3,
      status: AulaStatus.bloqueado,
    ),
    AulaModel(
      id: 2,
      templateId: 2,
      titulo: 'Técnicas Avançadas de Gestão',
      descricao: '',
      urlVideo:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      urlMaterial: '',
      capa: '',
      ordem: 2,
      status: AulaStatus.emAndamento,
    ),
  ];

  @override
  Future<ResultActionDTO<List<AulaModel>>> getAulas({
    required int cursoId,
    required String usuarioId,
  }) async {
    try {
      // final result = await _restClient.post(ApiRoutes.aulas(), {
      //   'cursoId': cursoId,
      //   'usuarioId': usuarioId,
      // });
      // if (result.statusCode! >= 400) {
      //   return ResultActionDTO.failure(
      //     'Não foi possível buscar as aulas deste curso.',
      //     [],
      //   );
      // }
      // return ResultActionDTO.success(data: result.body);
      return ResultActionDTO.success(data: _aulas);
    } catch (e, s) {
      log('Erro ao buscar aulas', error: e, stackTrace: s);
      return ResultActionDTO.failure('Algo deu errado', []);
    }
  }
}
