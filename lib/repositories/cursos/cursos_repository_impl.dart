import 'dart:developer';

import 'package:posto360/core/dto/result_action_dto.dart';
import 'package:posto360/core/rest_client/api_routes/api_routes.dart';
import 'package:posto360/core/rest_client/posto_rest_client.dart';
import 'package:posto360/core/utils/enums/curso_status.dart';
import 'package:posto360/models/curso_model.dart';

import './cursos_repository.dart';

class CursosRepositoryImpl extends CursosRepository {
  final PostoRestClient _restClient;

  CursosRepositoryImpl({required PostoRestClient postoRestClient})
    : _restClient = postoRestClient;

  final _cursos = <CursoModel>[
    CursoModel(
      id: 1,
      templateId: 3,
      titulo: 'Gestão de vendas e liderança',
      descricao:
          'Aprenda a motivar, engajar e desenvolver sua equipe para alcançar alta performance.',
      capa:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSekiWFjm6XNLBwvIiQDiRrascUYZVHaLWYsA&s',
      status: CursoStatus.andamento,
      totalAulas: 30,
      aulasConcluidas: 12,
      inscricao: '12/07/2024',
      ultimoAcesso: '13/07/2024',
      duracaoMedia: 200,
      certificadoEmitido: false,
      tipoUsuario: 'Vendedor',
    ),
    CursoModel(
      id: 4,
      templateId: 3,
      titulo: 'Coletando Feedback ',
      descricao:
          'Aprenda a motivar, engajar e desenvolver sua equipe para alcançar alta performance.',
      capa:
          'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRCCe1eXodCe5e0JwIe1d-QSa-vpLadvdAmcQ&s',
      status: CursoStatus.andamento,
      totalAulas: 10,
      aulasConcluidas: 8,
      inscricao: '12/07/2024',
      ultimoAcesso: '13/07/2024',
      duracaoMedia: 57,
      certificadoEmitido: false,
      tipoUsuario: 'Vendedor',
    ),
    CursoModel(
      id: 2,
      templateId: 2,
      titulo: 'Inteligência Emocional',
      descricao:
          'Desenvolva habilidades emocionais para uma gestão mais equilibrada e eficaz.',
      capa: 'https://ibdec.net/wp-content/uploads/2018/08/inteligencia.jpg',
      status: CursoStatus.finalizado,
      totalAulas: 36,
      aulasConcluidas: 36,
      inscricao: '12/07/2024',
      ultimoAcesso: '13/07/2024',
      duracaoMedia: 147,
      certificadoEmitido: true,
      tipoUsuario: 'Vendedor',
    ),
  ];
  @override
  Future<ResultActionDTO<List<CursoModel>>> getCursos({
    required String usuarioId,
  }) async {
    try {
      // final response = await _restClient.post(ApiRoutes.cursos(), {
      //   'usuarioId': usuarioId,
      // });
      // final cursos =
      //     response.body
      //         .map<CursoModel>((curso) => CursoModel.fromMap(curso))
      //         .toList() ??
      //     [];
      return ResultActionDTO.success(data: _cursos);
    } catch (e, s) {
      log('Erro get campanhas', error: e, stackTrace: s);
      return ResultActionDTO.failure('Não foi possível obter os cursos', []);
    }
  }
}
