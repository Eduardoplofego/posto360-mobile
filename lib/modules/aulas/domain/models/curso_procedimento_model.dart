/// Procedimento da empresa vinculado a um curso.
///
/// Vem resumido dentro de cada curso em `/api/mobile/ead/vendedor/cursos`
/// (só id, nome e descrição). O passo a passo completo é carregado pela tela
/// de detalhe do procedimento, em `/procedimentos/:id`.
class CursoProcedimentoModel {
  final int id;
  final String nome;
  final String descricao;

  CursoProcedimentoModel({
    required this.id,
    required this.nome,
    required this.descricao,
  });

  factory CursoProcedimentoModel.fromMap(Map<String, dynamic> map) {
    return CursoProcedimentoModel(
      id: map['id'] ?? 0,
      nome: map['nome'] ?? '',
      descricao: map['descricao'] ?? '',
    );
  }

  @override
  String toString() =>
      'CursoProcedimentoModel(id: $id, nome: $nome, descricao: $descricao)';
}
