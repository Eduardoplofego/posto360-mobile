import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvironmentsVariables {
  static String get supaseBackendUrl => _getString('supaseBackendUrl');
  static String get anonKEY => _getString('anonKey');

  static String _getString(String key) => dotenv.env[key] ?? '';
}
