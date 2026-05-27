import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:posto360/modules/chamados/domain/models/chamado_campo_foto_model.dart';
import 'package:posto360/modules/chamados/domain/models/chamado_campo_model.dart';
import 'package:posto360/modules/core/domain/ui/posto_app_ui_configurations.dart';

class CampoPhotoWidget extends StatelessWidget {
  final ChamadoCampoModel campo;

  const CampoPhotoWidget({super.key, required this.campo});

  @override
  Widget build(BuildContext context) {
    if (campo.fotos.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Icon(
              Icons.image_not_supported_outlined,
              size: 20,
              color: PostoAppUiConfigurations.darkGreyColor,
            ),
            const SizedBox(width: 8),
            Text(
              'Nenhuma foto enviada',
              style: TextStyle(
                fontSize: 13,
                color: PostoAppUiConfigurations.darkGreyColor,
              ),
            ),
          ],
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: campo.fotos.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final foto = campo.fotos[index];
        return _PhotoTile(
          foto: foto,
          onTap: () => _openViewer(context, campo.fotos, index),
        );
      },
    );
  }

  void _openViewer(
    BuildContext context,
    List<ChamadoCampoFotoModel> fotos,
    int initialIndex,
  ) {
    Get.to(
      () => _PhotoViewerPage(fotos: fotos, initialIndex: initialIndex),
      opaque: false,
      fullscreenDialog: true,
      transition: Transition.fadeIn,
    );
  }
}

class _PhotoTile extends StatelessWidget {
  final ChamadoCampoFotoModel foto;
  final VoidCallback onTap;

  const _PhotoTile({required this.foto, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Hero(
        tag: 'chamado-foto-${foto.url}',
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            foto.url,
            fit: BoxFit.cover,
            loadingBuilder: (context, child, progress) {
              if (progress == null) return child;
              return Container(
                color: const Color(0xFFF3F4F6),
                child: Center(
                  child: SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: PostoAppUiConfigurations.blueMediumColor,
                    ),
                  ),
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: const Color(0xFFF3F4F6),
                child: Center(
                  child: Icon(
                    Icons.broken_image_outlined,
                    color: PostoAppUiConfigurations.darkGreyColor,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _PhotoViewerPage extends StatefulWidget {
  final List<ChamadoCampoFotoModel> fotos;
  final int initialIndex;

  const _PhotoViewerPage({required this.fotos, required this.initialIndex});

  @override
  State<_PhotoViewerPage> createState() => _PhotoViewerPageState();
}

class _PhotoViewerPageState extends State<_PhotoViewerPage> {
  late final PageController _controller;
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex;
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final total = widget.fotos.length;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text(
          '${_index + 1} de $total',
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
        ),
        leading: IconButton(
          icon: const Icon(Icons.close_rounded),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: PageView.builder(
        controller: _controller,
        itemCount: total,
        onPageChanged: (i) => setState(() => _index = i),
        itemBuilder: (context, i) {
          final foto = widget.fotos[i];
          return Center(
            child: Hero(
              tag: 'chamado-foto-${foto.url}',
              child: InteractiveViewer(
                minScale: 1,
                maxScale: 4,
                child: Image.network(
                  foto.url,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(
                      child: CircularProgressIndicator(color: Colors.white),
                    );
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Center(
                      child: Icon(
                        Icons.broken_image_outlined,
                        color: Colors.white54,
                        size: 48,
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
