class ImageAnswerDto {
  final String name;
  final String type;
  final String base64;

  ImageAnswerDto({
    required this.name,
    required this.type,
    required this.base64,
  });

  Map<String, dynamic> toJson() {
    return {'nome': name, 'tipo': type, 'base64': base64};
  }
}
