import 'package:get/get.dart';
import 'package:posto360/core/mixins/loader_mixin.dart';
import 'package:posto360/core/utils/enums/curso_status.dart';
import 'package:posto360/models/curso_model.dart';

class CursosController extends GetxController with LoaderMixin {
  CursosController();

  @override
  void onInit() {
    loaderListener(_loading);
    _cursosSearched.assignAll(Get.arguments ?? []);
    _cursos.assignAll(_cursosSearched);
    super.onInit();
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await _init();
  }

  // Observables
  final _loading = false.obs;
  final _totalCursos = 0.obs;
  final _cursosFinalizados = 0.obs;
  final _totalAulas = 0.obs;
  final _aulasRealizadas = 0.obs;
  final _totalCertificados = 0.obs;
  final _certificadosEmitidos = 0.obs;
  final _searchText = 'Texto'.obs;
  final _isConcludedCursosSelected = false.obs;
  final _cursos = <CursoModel>[].obs;
  final _cursosSearched = <CursoModel>[].obs;
  final _cursosConluidos = <CursoModel>[].obs;
  final _cursosEmAndamento = <CursoModel>[].obs;

  // Getters
  int get totalCursos => _totalCursos.value;
  int get cursosFinalizados => _cursosFinalizados.value;
  int get aulasFinalizadas => _aulasRealizadas.value;
  int get totalAulas => _totalAulas.value;
  int get totalCertificados => _totalCertificados.value;
  int get certificadosEmitidos => _certificadosEmitidos.value;
  String get searchText => _searchText.value;
  bool get isConcludedCursosSelected => _isConcludedCursosSelected.value;
  List<CursoModel> get cursosToShow =>
      isConcludedCursosSelected ? _cursosConluidos : _cursosEmAndamento;

  List<CursoModel> get cursosConcluidos => _cursosConluidos;
  List<CursoModel> get cursosEmAndamento => _cursosEmAndamento;

  // Actions
  void onSearchChanged(String text) {
    _searchText.value = text;
    if (text.isEmpty) {
      _cursosSearched.assignAll(_cursos);
      _cursosConluidos.assignAll(
        _cursosSearched
            .where((curso) => curso.status == CursoStatus.finalizado)
            .toList(),
      );
      _cursosEmAndamento.assignAll(
        _cursosSearched
            .where((curso) => curso.status == CursoStatus.andamento)
            .toList(),
      );
    } else {
      final cursosPesquisados =
          _cursosSearched
              .where(
                (curso) =>
                    curso.titulo.toLowerCase().contains(text.toLowerCase()),
              )
              .toList();
      _cursosSearched.assignAll(cursosPesquisados);
      _cursosConluidos.assignAll(
        cursosPesquisados
            .where((curso) => curso.status == CursoStatus.finalizado)
            .toList(),
      );
      _cursosEmAndamento.assignAll(
        cursosPesquisados
            .where((curso) => curso.status == CursoStatus.andamento)
            .toList(),
      );
    }
  }

  void changeSelectedTab(int index) {
    _isConcludedCursosSelected.value = index == 1;
  }

  Future<void> onRefresh() async {
    initVariables();
    await _init();
  }

  void initVariables() {
    _totalCursos.value = 0;
    _totalAulas.value = 0;
    _aulasRealizadas.value = 0;
    _certificadosEmitidos.value = 0;
    _totalCertificados.value = 0;
    _cursosFinalizados.value = 0;
    _cursosConluidos.assignAll([]);
    _cursosEmAndamento.assignAll([]);
  }

  Future<void> _init() async {
    _loading(true);
    await _loadCursos();
    _loading(false);
  }

  Future<void> _loadCursos() async {
    for (var curso in _cursos) {
      _totalCursos.value += 1;
      _totalAulas.value += curso.totalAulas;
      _aulasRealizadas.value += curso.aulasConcluidas;
      _certificadosEmitidos.value += curso.certificadoEmitido == true ? 1 : 0;
      _totalCertificados.value += 1;
      if (curso.status == CursoStatus.andamento) {
        _cursosEmAndamento.add(curso);
      } else if (curso.status == CursoStatus.finalizado) {
        _cursosFinalizados.value += 1;
        _cursosConluidos.add(curso);
      }
    }
  }
}
