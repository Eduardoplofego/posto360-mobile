import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:posto360/posto_app.dart';

Future<void> main() async {
  await GetStorage.init();
  initializeDateFormatting('pt_BR', null).then((_) => runApp(const PostoApp()));
  // runApp(const PostoApp());
}
