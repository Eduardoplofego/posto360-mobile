import 'package:dio/dio.dart';

abstract class RestClient {
  Future<Response> get(String path, {Map<String, dynamic>? queryParameters});

  Future<Response> post(String path, {Map<String, dynamic>? data});

  Future<Response> patch(String path, {Map<String, dynamic>? data});
}
