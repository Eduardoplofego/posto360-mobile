import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:posto360/posto_app.dart';

Future<void> main() async {
  await GetStorage.init();
  runApp(const PostoApp());
}
