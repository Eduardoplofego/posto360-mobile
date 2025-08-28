import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:posto360/core/utils/environments_variables.dart';
import 'package:posto360/posto_app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); // <-- Primeiro de tudo!

  await dotenv.load(
    fileName: '.env',
  ); // Agora sim o flutter pode buscar o asset
  await GetStorage.init();

  await Supabase.initialize(
    url: EnvironmentsVariables.supaseBackendUrl,
    anonKey: EnvironmentsVariables.anonKEY,
  );

  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  await initializeDateFormatting('pt_BR', null);

  runApp(const PostoApp());
}
