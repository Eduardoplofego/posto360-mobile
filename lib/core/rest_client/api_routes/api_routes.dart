class ApiRoutes {
  ApiRoutes._();

  static const _login = '/api/login';
  static const _honorary = '/api/horario-faltas-atrasos';
  static const _products = '/api/produtos-incentivados';
  static const _performance = '/api/calcular-performance';

  static String login() => _login;
  static String honorario() => _honorary;
  static String produtos() => _products;
  static String performance() => _performance;
}
