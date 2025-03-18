class ApiRoutes {
  ApiRoutes._();

  static const _backendBaseUrl = 'https://www.posto360.app';

  static const _login = '$_backendBaseUrl/api/login';
  static const _honorary = '$_backendBaseUrl/api/horario-faltas-atrasos';
  static const _products = '$_backendBaseUrl/api/produtos-incentivados';
  static const _performance = '$_backendBaseUrl/api/calcular-performance';

  static String login() => _login;
  static String honorario() => _honorary;
  static String produtos() => _products;
  static String performance() => _performance;
}
