import 'dart:convert';

import 'package:get/get.dart';
import 'package:posto360/modules/chamados/domain/models/chamado_campo_model.dart';
import 'package:posto360/modules/chamados/domain/models/chamado_model.dart';
import 'package:posto360/modules/chamados/domain/models/upload_photo_dto.dart';
import 'package:posto360/modules/chamados/infra/services/chamados_service.dart';

class ChamadoEditarController extends GetxController {
  final int chamadoId;
  final ChamadoModel? chamadoArg;
  final ChamadosService _chamadosService;

  ChamadoEditarController({
    required this.chamadoId,
    required this.chamadoArg,
    required ChamadosService chamadosService,
  }) : _chamadosService = chamadosService;

  final _loading = false.obs;
  final _saving = false.obs;
  final _errorMessage = ''.obs;
  final _campos = <ChamadoCampoModel>[].obs;
  final _editsTexto = <int, String>{}.obs;
  final _photoDeletions = <int, Set<String>>{}.obs;
  final _photoUploads = <int, List<UploadPhotoDto>>{}.obs;

  bool get isLoading => _loading.value;
  bool get isSaving => _saving.value;
  String get errorMessage => _errorMessage.value;
  bool get hasError => _errorMessage.value.isNotEmpty;
  List<ChamadoCampoModel> get campos => _campos.toList();
  ChamadoModel? get chamado => chamadoArg;

  String? valorTextoAtual(ChamadoCampoModel campo) {
    return _editsTexto[campo.id] ?? campo.valorTexto;
  }

  bool isFotoMarcadaParaExclusao(int campoId, String url) =>
      _photoDeletions[campoId]?.contains(url) ?? false;

  List<UploadPhotoDto> uploadsFor(int campoId) =>
      _photoUploads[campoId] ?? const [];

  void toggleExclusaoFoto(int campoId, String url) {
    final atual = Set<String>.from(_photoDeletions[campoId] ?? <String>{});
    if (atual.contains(url)) {
      atual.remove(url);
    } else {
      atual.add(url);
    }
    _photoDeletions[campoId] = atual;
  }

  void adicionarUpload(int campoId, UploadPhotoDto foto) {
    final atual = List<UploadPhotoDto>.from(
      _photoUploads[campoId] ?? <UploadPhotoDto>[],
    );
    atual.add(foto);
    _photoUploads[campoId] = atual;
  }

  void removerUpload(int campoId, int index) {
    final atual = List<UploadPhotoDto>.from(
      _photoUploads[campoId] ?? <UploadPhotoDto>[],
    );
    if (index >= 0 && index < atual.length) {
      atual.removeAt(index);
      _photoUploads[campoId] = atual;
    }
  }

  bool temAlteracoes() {
    if (_editsTexto.isNotEmpty) return true;
    if (_photoDeletions.values.any((s) => s.isNotEmpty)) return true;
    if (_photoUploads.values.any((l) => l.isNotEmpty)) return true;
    return false;
  }

  bool campoPendente(ChamadoCampoModel campo) {
    if (!campo.obrigatorio) return false;
    if (campo.tipo == ChamadoCampoTipo.photo) {
      final mantidas = campo.fotos
          .where((f) => !isFotoMarcadaParaExclusao(campo.id, f.url))
          .length;
      final novas = uploadsFor(campo.id).length;
      return (mantidas + novas) == 0;
    }
    final v = (valorTextoAtual(campo) ?? '').trim();
    return v.isEmpty;
  }

  List<ChamadoCampoModel> get camposPendentes =>
      _campos.where(campoPendente).toList();

  void setValorTexto(int campoId, String? valor) {
    if (valor == null) {
      _editsTexto.remove(campoId);
    } else {
      _editsTexto[campoId] = valor;
    }
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await _loadCampos();
  }

  Future<void> onRefresh() async {
    await _loadCampos();
  }

  Future<void> _loadCampos() async {
    _loading.value = true;
    _errorMessage.value = '';
    if (chamadoId == 0) {
      _errorMessage.value = 'Chamado inválido.';
      _loading.value = false;
      return;
    }
    final result = await _chamadosService.getCamposChamado(
      chamadoId: chamadoId,
    );
    if (result.success) {
      _campos.assignAll(result.data ?? []);
      _editsTexto.clear();
      _photoDeletions.clear();
      _photoUploads.clear();
    } else {
      _errorMessage.value = result.message;
      _campos.clear();
    }
    _loading.value = false;
  }

  Future<({bool ok, String? error})> salvar() async {
    final pendentes = camposPendentes;
    if (pendentes.isNotEmpty) {
      final nomes = pendentes.map((c) => c.descricao).join(', ');
      return (
        ok: false,
        error: 'Preencha os campos obrigatórios: $nomes',
      );
    }
    final payload = _montarPayload();
    if (payload.isEmpty) {
      return (ok: true, error: null);
    }
    _saving.value = true;
    final result = await _chamadosService.atualizarCampos(
      chamadoId: chamadoId,
      campos: payload,
    );
    if (result.success) {
      await _loadCampos();
      _saving.value = false;
      return (ok: true, error: null);
    }
    _saving.value = false;
    return (ok: false, error: result.message);
  }

  List<Map<String, dynamic>> _montarPayload() {
    final out = <Map<String, dynamic>>[];
    for (final campo in _campos) {
      if (campo.tipo == ChamadoCampoTipo.photo) {
        final deletions = _photoDeletions[campo.id] ?? <String>{};
        final uploads = _photoUploads[campo.id] ?? <UploadPhotoDto>[];
        if (deletions.isEmpty && uploads.isEmpty) continue;
        final entries = <Map<String, dynamic>>[];
        for (final foto in campo.fotos) {
          if (deletions.contains(foto.url)) {
            entries.add({'url': foto.url, 'action': 'delete'});
          } else {
            entries.add({'url': foto.url, 'action': null});
          }
        }
        for (final upload in uploads) {
          entries.add({
            'action': 'upload',
            'dadosUpload': {
              'nome': upload.nome,
              'tipo': upload.tipo,
              'base64': base64Encode(upload.bytes),
            },
          });
        }
        out.add({
          'id': campo.id,
          'tipo': campo.tipoRaw,
          'valorJson': entries,
        });
      } else {
        if (!_editsTexto.containsKey(campo.id)) continue;
        out.add({
          'id': campo.id,
          'tipo': campo.tipoRaw,
          'valorTexto': _editsTexto[campo.id],
        });
      }
    }
    return out;
  }
}
