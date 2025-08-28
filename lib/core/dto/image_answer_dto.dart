import 'dart:typed_data';

class ImageAnswerDto {
  final String name;
  final String type;
  final Uint8List imageRaw;

  ImageAnswerDto({
    required this.name,
    required this.type,
    required this.imageRaw,
  });

  Map<String, dynamic> toJson() {
    return {'nome': name, 'tipo': type, 'imageRaw': imageRaw};
  }
}
