import 'package:posto360/modules/motoristas/domain/models/filial_motorista_model.dart';

class DashboardMotoristaModel {
  final DateTime data;
  final List<FilialMotoristaModel> filiais;

  DashboardMotoristaModel({required this.data, required this.filiais});

  factory DashboardMotoristaModel.fromMap(Map<String, dynamic> map) {
    final filiaisRaw = (map['filiais'] as List?) ?? const [];
    return DashboardMotoristaModel(
      data: DateTime.parse(map['data'] as String),
      filiais: filiaisRaw
          .map((f) => FilialMotoristaModel.fromMap(f as Map<String, dynamic>))
          .toList(),
    );
  }
}
