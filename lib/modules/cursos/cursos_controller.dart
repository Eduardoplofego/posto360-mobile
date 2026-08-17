import 'package:get/get.dart';
import 'package:posto360/modules/core/domain/mixins/loader_mixin.dart';
import 'package:posto360/modules/core/domain/mixins/message_mixin.dart';
import 'package:posto360/modules/core/domain/services/auth_service.dart';
import 'package:posto360/modules/core/domain/utils/enums/curso_status.dart';
import 'package:posto360/modules/aulas/domain/models/curso_model.dart';
import 'package:posto360/modules/cursos/infra/services/cursos_service.dart';

class CursosController extends GetxController with LoaderMixin, MessageMixin {
  final CursosService _cursosService;

  CursosController({required CursosService cursosService})
    : _cursosService = cursosService;

  @override
  void onInit() {
    super.onInit();
    loaderListener(_loading);
    messageListener(_message);
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await _init();
  }

  // Observables
  final _cursos = <CursoModel>[].obs;

  final _loading = false.obs;
  final _message = Rxn<MessagesModel>();
  final _searchText = ''.obs;
  final _isConcludedCursosSelected = false.obs;
  final _cursosConluidos = <CursoModel>[].obs;
  final _cursosEmAndamento = <CursoModel>[].obs;

  // Getters
  int get totalCursos => _cursos.length;
  int get cursosFinalizados =>
      _cursos
          .where((curso) => curso.status == CursoStatus.finalizado)
          .toList()
          .length;
  int get aulasFinalizadas {
    var aulasCount = 0;
    for (var curso in _cursos) {
      aulasCount += curso.aulasConcluidas;
    }
    return aulasCount;
  }

  int get totalAulas {
    var aulasCount = 0;
    for (var curso in _cursos) {
      aulasCount += curso.totalAulas;
    }
    return aulasCount;
  }

  int get totalCertificados => totalCursos;
  int get certificadosEmitidos =>
      _cursos.where((curso) => curso.certificadoEmitido).toList().length;
  String get searchText => _searchText.value;
  bool get isConcludedCursosSelected => _isConcludedCursosSelected.value;
  List<CursoModel> get cursosToShow =>
      isConcludedCursosSelected ? cursosConcluidos : cursosEmAndamento;

  List<CursoModel> get cursosConcluidos => _cursosConluidos;
  List<CursoModel> get cursosEmAndamento => _cursosEmAndamento;

  // Actions
  void onSearchChanged(String text) {
    _searchText.value = text;
    _aplicarFiltros();
  }

  void changeSelectedTab(int index) {
    _isConcludedCursosSelected.value = index == 1;
  }

  /// Reaplica a busca sempre sobre a lista completa (`_cursos`), para que
  /// apagar caracteres volte a exibir os cursos filtrados anteriormente.
  void _aplicarFiltros() {
    final busca = _searchText.value.trim().toLowerCase();
    final Iterable<CursoModel> filtrados =
        busca.isEmpty
            ? _cursos
            : _cursos.where(
              (curso) => curso.titulo.toLowerCase().contains(busca),
            );

    _cursosConluidos.assignAll(
      filtrados.where((curso) => curso.status == CursoStatus.finalizado),
    );
    _cursosEmAndamento.assignAll(
      filtrados.where((curso) => curso.status != CursoStatus.finalizado),
    );
  }

  Future<void> onRefresh() async {
    await _init();
  }

  Future<void> _init() async {
    _loading(true);
    await loadCursos();
    _loading(false);
  }

  Future<void> loadCursos() async {
    final user = Get.find<AuthService>().authenticatedUser;
    if (user != null) {
      final result = await _cursosService.getAllCursos(usuarioId: user.id);
      if (result.success) {
        _cursos.assignAll(result.data!);
        _aplicarFiltros();
      }
    }
  }

  Future<bool> startCurso({required int cursoId}) async {
    final user = Get.find<AuthService>().authenticatedUser;
    if (user != null) {
      final result = await _cursosService.iniciarCurso(
        usuarioId: user.id,
        cursoId: cursoId,
      );

      return result.data ?? false;
    }
    return false;
  }

  void showMessageError(String message) {
    _message(
      MessagesModel(title: 'Erro', message: message, type: MessageType.error),
    );
  }
}
