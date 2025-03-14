import 'dart:convert';

class UserModel {
  final String id;
  final DateTime createdAt;
  final String photoUrl;
  final String name;
  final String lastName;
  final String idEmpresa;
  final String tipoUsuario;
  final String? idFilial;
  final String? codigoPDV;
  final String? userName;
  final DateTime? dismissedDate;
  final DateTime? admissionDate;
  final String? ponto;

  UserModel({
    required this.id,
    required this.createdAt,
    required this.photoUrl,
    required this.name,
    required this.lastName,
    required this.idEmpresa,
    required this.tipoUsuario,
    this.idFilial,
    this.codigoPDV,
    this.userName,
    this.dismissedDate,
    this.admissionDate,
    this.ponto,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'photoUrl': photoUrl,
      'name': name,
      'lastName': lastName,
      'idEmpresa': idEmpresa,
      'tipoUsuario': tipoUsuario,
      'idFilial': idFilial,
      'codigoPDV': codigoPDV,
      'userName': userName,
      'dismissedDate': dismissedDate?.millisecondsSinceEpoch,
      'admissionDate': admissionDate?.millisecondsSinceEpoch,
      'ponto': ponto,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt']),
      photoUrl: map['photoUrl'] ?? '',
      name: map['name'] ?? '',
      lastName: map['lastName'] ?? '',
      idEmpresa: map['idEmpresa'] ?? '',
      tipoUsuario: map['tipoUsuario'] ?? '',
      idFilial: map['idFilial'],
      codigoPDV: map['codigoPDV'],
      userName: map['userName'],
      dismissedDate:
          map['dismissedDate'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['dismissedDate'])
              : null,
      admissionDate:
          map['admissionDate'] != null
              ? DateTime.fromMillisecondsSinceEpoch(map['admissionDate'])
              : null,
      ponto: map['ponto'],
    );
  }

  String toJson() => json.encode(toMap());

  factory UserModel.fromJson(String source) =>
      UserModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UserModel(id: $id, createdAt: $createdAt, photoUrl: $photoUrl, name: $name, lastName: $lastName, idEmpresa: $idEmpresa, tipoUsuario: $tipoUsuario, idFilial: $idFilial, codigoPDV: $codigoPDV, userName: $userName, dismissedDate: $dismissedDate, admissionDate: $admissionDate, ponto: $ponto)';
  }
}
