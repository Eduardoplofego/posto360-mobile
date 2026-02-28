class ApiRoutes {
  ApiRoutes._();

  static const _backendBaseUrl = 'https://www.posto360.app';

  static const _login = '$_backendBaseUrl/api/mobile/login';
  static const _honorary = '$_backendBaseUrl/api/mobile/horario-faltas-atrasos';
  static const _campanhas =
      '$_backendBaseUrl/api/mobile/produtos-incentivados/detalhes';
  static const _performanceIndividual =
      '$_backendBaseUrl/api/mobile/produtos-incentivados/performance-individual';
  static const _performanceEquipe =
      '$_backendBaseUrl/api/mobile/produtos-incentivados/performance-coletiva';
  static const _cursos = '$_backendBaseUrl/api/mobile/ead/vendedor/cursos';
  static const _iniciarCurso =
      '$_backendBaseUrl/api/mobile/ead/vendedor/iniciar-curso';
  static const _aulas = '$_backendBaseUrl/api/mobile/ead/vendedor/aulas';
  static const _aulaConcluida =
      '$_backendBaseUrl/api/mobile/ead/vendedor/subir-visualizacao';
  static const _dashboard = '$_backendBaseUrl/api/mobile/dashboard';
  static const _dashboardRH = '$_backendBaseUrl/api/mobile/dashboard/rh';
  static const _dashboardFinanceiro =
      '$_backendBaseUrl/api/mobile/dashboard/financeiro';
  static const _dashboardCampanhas =
      '$_backendBaseUrl/api/mobile/dashboard/campanhas';
  static const _dashboardCursos =
      '$_backendBaseUrl/api/mobile/dashboard/cursos';
  static const _dashboardChecklists =
      '$_backendBaseUrl/api/mobile/dashboard/checklist';
  static const _checklists =
      '$_backendBaseUrl/api/mobile/checklists/vendedor/disponiveis';
  static const _checklistFinalizadas =
      '$_backendBaseUrl/api/mobile/checklists/vendedor/finalizados';
  static const _checklistAnswers =
      '$_backendBaseUrl/api/mobile/checklists/vendedor/respostas';
  static const _iniciarChecklist =
      '$_backendBaseUrl/api/mobile/checklists/vendedor/iniciar-checklist';
  static const _finalizarChecklist =
      '$_backendBaseUrl/api/mobile/checklists/vendedor/finalizar-checklist';
  static const _subirResposta =
      '$_backendBaseUrl/api/mobile/checklists/vendedor/subir-resposta';
  static const _subirImagem =
      '$_backendBaseUrl/api/mobile/checklists/vendedor/subir-imagem';
  static const _subirFotoPerfil =
      '$_backendBaseUrl/api/mobile/subir-foto-perfil';
  static const _fechamentoCaixa =
      '$_backendBaseUrl/api/mobile/fechamento-caixa';
  static const _fechamentoCaixaDetalhes =
      '$_backendBaseUrl/api/mobile/fechamento-caixa/detalhes';
  static const _registroPontosDetalhes =
      '$_backendBaseUrl/api/mobile/pontos/detalhes';

  static String login() => _login;
  static String honorario() => _honorary;
  static String campanhas() => _campanhas;
  static String performanceIndividual() => _performanceIndividual;
  static String performanceEquipe() => _performanceEquipe;
  static String cursos() => _cursos;
  static String iniciarCurso() => _iniciarCurso;
  static String aulas() => _aulas;
  static String aulaConcluida() => _aulaConcluida;
  static String dashboard() => _dashboard;
  static String dashboardRH() => _dashboardRH;
  static String dashboardFinanceiro() => _dashboardFinanceiro;
  static String dashboardCampanhas() => _dashboardCampanhas;
  static String dashboardCursos() => _dashboardCursos;
  static String dashboardChecklists() => _dashboardChecklists;
  static String checklists() => _checklists;
  static String checklistsFinalizadas() => _checklistFinalizadas;
  static String checklistAnswers() => _checklistAnswers;
  static String iniciarChecklist() => _iniciarChecklist;
  static String finalizarChecklist() => _finalizarChecklist;
  static String subirResposta() => _subirResposta;
  static String subirImagem() => _subirImagem;
  static String subirFotoPerfil() => _subirFotoPerfil;
  static String fechamentoCaixa() => _fechamentoCaixa;
  static String fechamentoCaixaDetalhes() => _fechamentoCaixaDetalhes;
  static String registroPontosDetalhes() => _registroPontosDetalhes;
}
