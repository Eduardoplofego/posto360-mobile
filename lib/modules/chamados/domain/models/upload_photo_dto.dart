import 'dart:typed_data';

class UploadPhotoDto {
  final String nome;
  final String tipo;
  final Uint8List bytes;

  UploadPhotoDto({
    required this.nome,
    required this.tipo,
    required this.bytes,
  });
}
