class ApiRoutes {
  ApiRoutes._();

  static const _backendBaseUrl = 'https://www.posto360.app';

  static const _login = '$_backendBaseUrl/api/login';
  static const _honorary = '$_backendBaseUrl/api/horario-faltas-atrasos';
  static const _campanhas = '$_backendBaseUrl/api/produtos-incentivados';
  static const _performance = '$_backendBaseUrl/api/calcular-performance';
  static const _cursos = '$_backendBaseUrl/api/ead/vendedor/cursos';
  static const _aulas = '$_backendBaseUrl/api/ead/vendedor/aulas';
  static const _aulaConcluida =
      '$_backendBaseUrl/api/ead/vendedor/subir-visualizacao';
  static const _dashboard = '$_backendBaseUrl/api/mobile/dashboard';
  static const _checklists =
      '$_backendBaseUrl/api/checklists/vendedor/disponiveis';
  static const _checklistAnswers =
      '$_backendBaseUrl/api/checklists/vendedor/respostas';
  static const _iniciarChecklist =
      '$_backendBaseUrl/api/checklists/vendedor/iniciar-checklist';
  static const _subirResposta =
      '$_backendBaseUrl/api/checklists/vendedor/subir-resposta';
  static const _subirImagem =
      '$_backendBaseUrl/api/checklists/vendedor/subir-imagem';

  static String login() => _login;
  static String honorario() => _honorary;
  static String campanhas() => _campanhas;
  static String performance() => _performance;
  static String cursos() => _cursos;
  static String aulas() => _aulas;
  static String aulaConcluida() => _aulaConcluida;
  static String dashboard() => _dashboard;
  static String checklists() => _checklists;
  static String checklistAnswers() => _checklistAnswers;
  static String iniciarChecklist() => _iniciarChecklist;
  static String subirResposta() => _subirResposta;
  static String subirImagem() => _subirImagem;
}
