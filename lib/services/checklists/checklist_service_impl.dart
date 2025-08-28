import 'dart:typed_data';

import 'package:get/get.dart';
import 'package:posto360/core/dto/image_answer_dto.dart';
import 'package:posto360/core/dto/result_action_dto.dart';
import 'package:posto360/core/services/auth_service.dart';

import 'package:posto360/models/checklist_answer_model.dart';

import 'package:posto360/models/checklist_model.dart';
import 'package:posto360/repositories/checklists/checklists_repository.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import './checklist_service.dart';

class ChecklistServiceImpl extends ChecklistService {
  final ChecklistsRepository _checklistsRepository;

  ChecklistServiceImpl({required ChecklistsRepository checklistRepository})
    : _checklistsRepository = checklistRepository;

  @override
  Future<ResultActionDTO<List<ChecklistAnswerModel>>> checklistAnswer({
    required String usuarioId,
    required int checklistId,
  }) async => await _checklistsRepository.getChecklistAnswers(
    usuarioId: usuarioId,
    checklistId: checklistId,
  );

  @override
  Future<ResultActionDTO<List<ChecklistModel>>> getChechlists({
    required String usuarioId,
    required int filialId,
  }) async {
    final resultChecklistAvailables = await _checklistsRepository.getChechlists(
      usuarioId: usuarioId,
      filialId: filialId,
    );

    final resultChecklistConcluded = await _checklistsRepository
        .getChechlistsConcluded(usuarioId: usuarioId, filialId: filialId);

    if (resultChecklistAvailables.success && resultChecklistConcluded.success) {
      final checklists = <ChecklistModel>[];
      checklists.addAll(resultChecklistConcluded.data!.toList());
      checklists.addAll(resultChecklistAvailables.data!.toList());
      return ResultActionDTO.success(data: checklists);
    }

    return ResultActionDTO.failure(
      'Não foi possivel carregar as checklists',
      [],
    );
  }

  @override
  Future<ResultActionDTO<bool>> startChecklist({
    required String usuarioId,
    required int checklistId,
  }) async => await _checklistsRepository.startChecklist(
    usuarioId: usuarioId,
    checklistId: checklistId,
  );

  @override
  Future<ResultActionDTO<bool>> pushChecklistAnswer<T>({
    required int respostaId,
    required T resposta,
    String? observacoes,
    String? photoUrl,
    bool? necessitaRevisao,
  }) async => await _checklistsRepository.pushChecklistAnswer(
    respostaId: respostaId,
    resposta: resposta,
    observacoes: observacoes,
    photoUrl: photoUrl,
    necessitaRevisao: necessitaRevisao,
  );

  @override
  Future<ResultActionDTO<String>> subirImagem({
    required int respostaId,
    required ImageAnswerDto imageAnswer,
  }) async {
    final userAuth = Get.find<AuthService>().authenticatedUser;

    final photoUrl = await _uploadImagemResposta(
      userId: userAuth!.id,
      bytes: imageAnswer.imageRaw,
      fileName: imageAnswer.name,
      typeImage: imageAnswer.type,
    );

    if (photoUrl == '') {
      return ResultActionDTO.failure('Erro ao subir a imagem', photoUrl);
    }
    return ResultActionDTO.success(
      message: 'Imagem salva com sucesso',
      data: photoUrl,
    );
  }

  Future<String> _uploadImagemResposta({
    required String userId,
    required Uint8List bytes,
    required String fileName,
    required String typeImage,
  }) async {
    final supabase = Get.find<AuthService>().clientSupabase;
    try {
      final path =
          'respostas/$userId/${DateTime.now().millisecondsSinceEpoch}_$fileName';

      await supabase!.storage
          .from('imagens-respostas')
          .uploadBinary(
            path,
            bytes,
            fileOptions: FileOptions(contentType: typeImage, upsert: false),
          );

      final publicUrl = supabase.storage
          .from('imagens-respostas')
          .getPublicUrl(path);
      return publicUrl;
    } catch (e) {
      return '';
    }
  }

  @override
  Future<ResultActionDTO<bool>> finalizarChecklist({
    required int checklistId,
  }) async =>
      await _checklistsRepository.finalizarChecklist(checklistid: checklistId);
}
