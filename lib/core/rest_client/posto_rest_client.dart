import 'package:get/get_connect/connect.dart';
import 'package:get/get_connect/http/src/request/request.dart';
import 'package:get_storage/get_storage.dart';
import 'package:posto360/core/constants/constants.dart';

class PostoRestClient extends GetConnect {
  final _headers = {'content-type': 'application/json'};

  Request _applyHeaders(Request request) {
    _headers.forEach((key, value) => request.headers[key] = value);
    return request;
  }

  PostoRestClient() {
    httpClient.followRedirects = false;
    httpClient.addRequestModifier<Object?>((request) {
      final requestWithHeaders = _applyHeaders(request);
      final storage = GetStorage();
      final jtwToken = storage.read(Constants.JWT_TOKEN) as String?;
      if (jtwToken != null) {
        requestWithHeaders.headers['Authorization'] = jtwToken;
      }
      return requestWithHeaders;
    });
    httpClient.addResponseModifier((request, response) {
      if (response.statusCode == 401) {
        final storage = GetStorage();
        storage.write(Constants.JWT_TOKEN, null);
      }
      return response;
    });
  }
}
