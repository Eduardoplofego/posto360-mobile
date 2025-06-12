class LoginExcpetion implements Exception {
  final String message;

  LoginExcpetion({this.message = 'Erro ao fazer login'});
}
