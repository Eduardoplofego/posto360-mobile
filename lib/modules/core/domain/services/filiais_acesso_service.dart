import 'package:get/get.dart';

class FilialAcessoModel {
  final int id;
  final String nome;

  const FilialAcessoModel({required this.id, required this.nome});
}

/// Guarda as filiais que o usuário logado pode operar quando ele não trabalha
/// em uma filial só. Hoje isso vale para o motorista: ele é lotado numa filial
/// mas atende várias, então `UserModel.idFilial` sozinho não diz onde ele está
/// atuando.
///
/// O módulo que conhece essa lista publica aqui (motoristas, a partir do
/// dashboard) e quem precisa dela (chamados) lê sem depender do módulo de
/// origem.
class FiliaisAcessoService extends GetxService {
  final _filiais = <FilialAcessoModel>[].obs;

  List<FilialAcessoModel> get filiais => _filiais.toList();
  bool get hasFiliais => _filiais.isNotEmpty;

  void publicar(List<FilialAcessoModel> filiais) => _filiais.assignAll(filiais);

  void limpar() => _filiais.clear();
}
