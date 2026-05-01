class ChamadoCampoFotoModel {
  final String url;
  final String? action;

  ChamadoCampoFotoModel({required this.url, this.action});

  factory ChamadoCampoFotoModel.fromMap(Map<String, dynamic> map) {
    return ChamadoCampoFotoModel(
      url: map['url'] ?? '',
      action: map['action'],
    );
  }
}
