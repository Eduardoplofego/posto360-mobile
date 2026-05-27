import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:mime/mime.dart';
import 'package:posto360/modules/chamados/domain/models/chamado_campo_foto_model.dart';
import 'package:posto360/modules/chamados/domain/models/chamado_campo_model.dart';
import 'package:posto360/modules/chamados/domain/models/upload_photo_dto.dart';
import 'package:posto360/modules/core/domain/services/auth_service.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';

class EditarPhotoWidget extends StatelessWidget {
  final ChamadoCampoModel campo;
  final List<UploadPhotoDto> uploads;
  final bool Function(String url) isFotoMarcada;
  final void Function(String url) onToggleExclusao;
  final void Function(UploadPhotoDto foto) onAdicionarUpload;
  final void Function(int index) onRemoverUpload;

  const EditarPhotoWidget({
    super.key,
    required this.campo,
    required this.uploads,
    required this.isFotoMarcada,
    required this.onToggleExclusao,
    required this.onAdicionarUpload,
    required this.onRemoverUpload,
  });

  @override
  Widget build(BuildContext context) {
    final existentes = campo.fotos;
    final tiles = <Widget>[];

    for (final foto in existentes) {
      tiles.add(
        _ExistingTile(
          foto: foto,
          marcada: isFotoMarcada(foto.url),
          onToggle: () => onToggleExclusao(foto.url),
        ),
      );
    }
    for (var i = 0; i < uploads.length; i++) {
      tiles.add(
        _UploadTile(
          foto: uploads[i],
          onRemover: () => onRemoverUpload(i),
        ),
      );
    }
    tiles.add(_AddTile(onPressed: () => _abrirPicker(context)));

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 3,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: tiles,
    );
  }

  Future<void> _abrirPicker(BuildContext context) async {
    final source = await showModalBottomSheet<ImageSource>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE5E7EB),
                borderRadius: BorderRadius.circular(100),
              ),
            ),
            const SizedBox(height: 18),
            ListTile(
              leading: Icon(
                Icons.photo_camera_outlined,
                color: PostoAppUiConfigurations.blueMediumColor,
              ),
              title: const Text('Tirar foto'),
              onTap: () => Get.back(result: ImageSource.camera),
            ),
            ListTile(
              leading: Icon(
                Icons.photo_library_outlined,
                color: PostoAppUiConfigurations.blueMediumColor,
              ),
              title: const Text('Escolher da galeria'),
              onTap: () => Get.back(result: ImageSource.gallery),
            ),
          ],
        ),
      ),
    );
    if (source == null) return;
    final picked = await ImagePicker().pickImage(
      source: source,
      imageQuality: 75,
      maxWidth: 1600,
      maxHeight: 1600,
    );
    if (picked == null) return;
    final file = File(picked.path);
    final bytes = await file.readAsBytes();
    if (bytes.isEmpty) return;
    final mime = lookupMimeType(picked.path) ?? 'image/jpeg';
    final nome = _gerarNome(picked.path);
    onAdicionarUpload(
      UploadPhotoDto(nome: nome, tipo: mime, bytes: bytes),
    );
  }

  String _gerarNome(String path) {
    final user = Get.find<AuthService>().getUser();
    final nomeUser = (user?.name ?? 'user').replaceAll(' ', '_');
    final agora = DateTime.now();
    final dia = DateFormat('yyyyMMdd', 'pt_BR').format(agora);
    final hora = DateFormat('HHmmss', 'pt_BR').format(agora);
    final ext = path.split('.').last;
    return 'chamado_${nomeUser}_${dia}_$hora.$ext';
  }
}

class _ExistingTile extends StatelessWidget {
  final ChamadoCampoFotoModel foto;
  final bool marcada;
  final VoidCallback onToggle;

  const _ExistingTile({
    required this.foto,
    required this.marcada,
    required this.onToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: ColorFiltered(
            colorFilter: marcada
                ? const ColorFilter.matrix([
                    0.33, 0.33, 0.33, 0, 0,
                    0.33, 0.33, 0.33, 0, 0,
                    0.33, 0.33, 0.33, 0, 0,
                    0, 0, 0, 1, 0,
                  ])
                : const ColorFilter.matrix([
                    1, 0, 0, 0, 0,
                    0, 1, 0, 0, 0,
                    0, 0, 1, 0, 0,
                    0, 0, 0, 1, 0,
                  ]),
            child: Image.network(
              foto.url,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                color: const Color(0xFFF3F4F6),
                child: Icon(
                  Icons.broken_image_outlined,
                  color: PostoAppUiConfigurations.darkGreyColor,
                ),
              ),
            ),
          ),
        ),
        if (marcada)
          Container(
            decoration: BoxDecoration(
              color: const Color(0xFFB91C1C).withValues(alpha: 0.4),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFB91C1C), width: 2),
            ),
            child: const Center(
              child: Text(
                'EXCLUIR',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
        Positioned(
          top: 4,
          right: 4,
          child: Material(
            color: Colors.white,
            shape: const CircleBorder(),
            elevation: 2,
            child: InkWell(
              onTap: onToggle,
              customBorder: const CircleBorder(),
              child: Padding(
                padding: const EdgeInsets.all(4),
                child: Icon(
                  marcada ? Icons.undo_rounded : Icons.delete_outline_rounded,
                  size: 16,
                  color: marcada
                      ? PostoAppUiConfigurations.blueMediumColor
                      : const Color(0xFFB91C1C),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _UploadTile extends StatelessWidget {
  final UploadPhotoDto foto;
  final VoidCallback onRemover;

  const _UploadTile({required this.foto, required this.onRemover});

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.memory(foto.bytes, fit: BoxFit.cover),
        ),
        Positioned(
          left: 4,
          bottom: 4,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: PostoAppUiConfigurations.blueMediumColor,
              borderRadius: BorderRadius.circular(100),
            ),
            child: const Text(
              'NOVA',
              style: TextStyle(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        Positioned(
          top: 4,
          right: 4,
          child: Material(
            color: Colors.white,
            shape: const CircleBorder(),
            elevation: 2,
            child: InkWell(
              onTap: onRemover,
              customBorder: const CircleBorder(),
              child: const Padding(
                padding: EdgeInsets.all(4),
                child: Icon(
                  Icons.close_rounded,
                  size: 16,
                  color: Color(0xFFB91C1C),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _AddTile extends StatelessWidget {
  final VoidCallback onPressed;

  const _AddTile({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: PostoAppUiConfigurations.blueMediumColor.withValues(
              alpha: 0.4,
            ),
            width: 1.5,
            style: BorderStyle.solid,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.add_a_photo_outlined,
              color: PostoAppUiConfigurations.blueMediumColor,
              size: 22,
            ),
            const SizedBox(height: 4),
            Text(
              'Adicionar',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: PostoAppUiConfigurations.blueMediumColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
