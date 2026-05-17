import 'package:posto360/modules/motoristas/domain/models/carregamento_model.dart';
import 'package:posto360/modules/motoristas/domain/models/produto_medicao_model.dart';

class FilialMotoristaModel {
  final int id;
  final String nome;
  final int? codigo;
  final List<ProdutoMedicaoModel> produtos;
  final List<CarregamentoModel> carregamentosHoje;
  final List<CarregamentoModel> proximosCarregamentos;

  FilialMotoristaModel({
    required this.id,
    required this.nome,
    required this.codigo,
    required this.produtos,
    required this.carregamentosHoje,
    required this.proximosCarregamentos,
  });

  bool get hasProdutos => produtos.isNotEmpty;

  factory FilialMotoristaModel.fromMap(Map<String, dynamic> map) {
    final produtosRaw = (map['produtos'] as List?) ?? const [];
    final hojeRaw = (map['carregamentosHoje'] as List?) ?? const [];
    final proximosRaw = (map['proximosCarregamentos'] as List?) ?? const [];
    final produtos = produtosRaw
        .map((p) => ProdutoMedicaoModel.fromMap(p as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => a.nome.toLowerCase().compareTo(b.nome.toLowerCase()));
    return FilialMotoristaModel(
      id: map['id'] as int,
      nome: map['nome'] as String? ?? '',
      codigo: map['codigo'] as int?,
      produtos: produtos,
      carregamentosHoje: hojeRaw
          .map((c) => CarregamentoModel.fromMap(c as Map<String, dynamic>))
          .toList(),
      proximosCarregamentos: proximosRaw
          .map((c) => CarregamentoModel.fromMap(c as Map<String, dynamic>))
          .toList(),
    );
  }
}
