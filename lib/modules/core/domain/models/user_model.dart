import 'dart:convert';

class UserModel {
  final String id;
  final DateTime createdAt;
  final String? photoUrl;
  final String name;
  final String? lastName;
  final int idEmpresa;
  final String tipoUsuario;
  final int? idFilial;
  final int? codigoPDV;
  final String? userName;
  final String? dismissedDate;
  final String? admissionDate;
  final bool? ponto;

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

  factory UserModel.empty() {
    return UserModel(
      id: '',
      createdAt: DateTime(2000),
      photoUrl: '',
      name: '',
      lastName: '',
      idEmpresa: 0,
      tipoUsuario: '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'created_at': createdAt.toIso8601String(),
      'FotoPerfil': photoUrl,
      'Nome': name,
      'Sobrenome': lastName,
      'EmpresaId': idEmpresa,
      'TipoUsuario': tipoUsuario,
      'FilialId': idFilial,
      'CodigoPdv': codigoPDV,
      'Username': userName,
      'Demissao': dismissedDate,
      'Admissao': admissionDate,
      'Ponto': ponto,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'] ?? '',
      createdAt: DateTime.tryParse(map['created_at']) ?? DateTime(2000),
      photoUrl: map['FotoPerfil'] ?? '',
      name: map['Nome'] ?? '',
      lastName: map['Sobrenome'] ?? '',
      idEmpresa: map['EmpresaId'] ?? 0,
      tipoUsuario: map['TipoUsuario'] ?? '',
      idFilial: map['FilialId'],
      codigoPDV: map['CodigoPdv'],
      userName: map['Username'],
      dismissedDate: map['Demissao'],
      admissionDate: map['Admissao'],
      ponto: map['Ponto'],
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
