import 'package:posto360/modules/avaliacoes/domain/models/avaliacao_details_model.dart';
import 'package:posto360/modules/avaliacoes/domain/models/avaliacoes_avaliador_model.dart';
import 'package:posto360/modules/avaliacoes/domain/models/avaliacoes_model.dart';
import 'package:posto360/modules/avaliacoes/domain/models/user_model.dart';
import 'package:posto360/modules/avaliacoes/domain/repositories/avaliacoes_module_repository.dart';
import 'package:posto360/modules/avaliacoes/infra/services/avaliacoes_module_service.dart';

import 'package:posto360/modules/core/domain/dto/result_action_dto.dart';
import 'package:posto360/modules/core/domain/helpers/date_helper.dart';
import 'package:posto360/modules/core/domain/utils/data_formatters.dart';

class AvaliacoesModuleServiceImpl extends AvaliacoesModuleService {
  final AvaliacoesModuleRepository _repository;

  AvaliacoesModuleServiceImpl(this._repository);

  @override
  Future<ResultActionDTO<List<AvaliacoesModel>>> getAvaliacoesAvaliado({
    required DateTime dataMes,
    required String usuarioId,
  }) async {
    final (dataInicial, dataFinal) = DateHelper.getInitialAndLastCurrentDate(
      dataMes,
    );
    return await _repository.getAvaliacoesAvaliado(
      dataInicial: DataFormatters.formatarData(dataInicial),
      dataFinal: DataFormatters.formatarData(dataFinal),
      usuarioId: usuarioId,
    );
  }

  @override
  Future<ResultActionDTO<List<AvaliacaoDetailsModel>>> getCriterios({
    required int gestaoAvaliacaoId,
    required int modeloAvaliacaoId,
  }) async {
    return await _repository.getCriterios(
      gestaoAvaliacaoId: gestaoAvaliacaoId,
      modeloAvaliacaoId: modeloAvaliacaoId,
    );
  }

  @override
  Future<ResultActionDTO<List<AvaliacaoAvaliador>>> getAvaliacoesAvaliador({
    required DateTime dataMes,
    required String usuarioId,
  }) async {
    final (dataInicial, dataFinal) = DateHelper.getInitialAndLastCurrentDate(
      dataMes,
    );

    final finalizadas = await _repository.getAvaliadorFinalizadas(
      dataInicial: DataFormatters.formatarData(dataInicial),
      dataFinal: DataFormatters.formatarData(dataFinal),
      usuarioId: usuarioId,
    );

    if (finalizadas.isError) return finalizadas;

    final pendentes = await _repository.getAvaliadorPendentes(
      dataAtual: DataFormatters.formatarData(dataMes),
      usuarioId: usuarioId,
    );

    if (pendentes.isError) return pendentes;

    final avaliacoes = [...pendentes.data!, ...finalizadas.data!];

    return ResultActionDTO.success(data: avaliacoes);
  }

  @override
  Future<ResultActionDTO<List<UserAvaliationModel>>> getUsers({
    required int avaliacaoId,
  }) async {
    final users = await _repository.getUsers(avaliacaoId: avaliacaoId);

    if (users.isError) return users;

    final userNotAvaliated =
        users.data!.where((ele) => !ele.isAvaliated).toList();
    final usersAvaliated =
        users.data!.where((ele) => !userNotAvaliated.contains(ele)).toList();
    return ResultActionDTO.success(
      data: [...userNotAvaliated, ...usersAvaliated],
    );
  }

  @override
  Future<ResultActionDTO<String>> setUser({
    required int avaliacaoId,
    required String usuarioId,
  }) async {
    return _repository.setUser(avaliacaoId: avaliacaoId, usuarioId: usuarioId);
  }
}
