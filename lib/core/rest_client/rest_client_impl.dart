import 'package:dio/dio.dart';

import './rest_client.dart';

class RestClientImpl extends RestClient {
  late Dio _dio;

  RestClientImpl() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'http://posto360.app',
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        headers: {'Accept': 'application/json'},
      ),
    );
  }

  @override
  Future<Response> get(
    String path, {
    Map<String, dynamic>? queryParameters,
  }) async {
    final response = await _dio.get(path, queryParameters: queryParameters);
    return response;
  }

  @override
  Future<Response> patch(String path, {Map<String, dynamic>? data}) async {
    final response = await _dio.get(path, data: data);
    return response;
  }

  @override
  Future<Response> post(String path, {Map<String, dynamic>? data}) async {
    final response = await _dio.post(path, data: data);
    return response;
  }
}
