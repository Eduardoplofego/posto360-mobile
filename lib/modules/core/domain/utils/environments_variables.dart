class EnvironmentsVariables {
  static String get supaseBackendUrl =>
      const String.fromEnvironment('SUPABASE_BACKEND_URL');
  static String get anonKEY => const String.fromEnvironment('ANON_KEY');
}
