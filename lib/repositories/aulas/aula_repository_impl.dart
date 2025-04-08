import 'dart:developer';

import 'package:posto360/core/dto/result_action_dto.dart';
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
      urlMaterial:
          'https://drive.google.com/drive/folders/1DaWEjnQHdACYaX0Ofq-b5HXaSXASFDNe',
      capa: '',
      ordem: 1,
      status: AulaStatus.finalizado,
      duracao: 40,
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
      duracao: 32,
    ),
    AulaModel(
      id: 2,
      templateId: 2,
      titulo: 'Técnicas Avançadas de Gestão',
      descricao: '',
      urlVideo:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      urlMaterial:
          'https://drive.google.com/drive/folders/1DaWEjnQHdACYaX0Ofq-b5HXaSXASFDNe',
      capa: '',
      ordem: 2,
      status: AulaStatus.emAndamento,
      duracao: 72,
    ),
    AulaModel(
      id: 4,
      templateId: 2,
      titulo: 'Estratégias de Vendas e Negociação para Líderes pt2',
      descricao: '',
      urlVideo:
          'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      urlMaterial: '',
      capa: '',
      ordem: 4,
      status: AulaStatus.bloqueado,
      duracao: 36,
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

  @override
  Future<ResultActionDTO<bool>> concludeAula({required int aulaId}) async {
    try {
      // final result = await _restClient.post(ApiRoutes.aulas(), {
      //   'aulaId': aulaId,
      // });
      // return ResultActionDTO.success(data: true);
      return ResultActionDTO.success(data: true);
    } catch (e, s) {
      log('Erro ao visualizar aula', error: e, stackTrace: s);
      return ResultActionDTO.failure('Erro ao visualizar aula', false);
    }
  }
}
