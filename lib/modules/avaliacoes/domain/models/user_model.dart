class UserAvaliationModel {
  final String id;
  final String name;
  final String funcao;
  final bool isAvaliated;

  UserAvaliationModel({
    required this.id,
    required this.name,
    required this.funcao,
    required this.isAvaliated,
  });

  static UserAvaliationModel fromMap(Map<String, dynamic> model) {
    return UserAvaliationModel(
      id: model['id'],
      name: model['nome'],
      funcao: model['tipo'],
      isAvaliated: model['isAvaliated'] ?? false,
    );
  }
}
