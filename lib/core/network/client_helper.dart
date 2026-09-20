import 'package:dio/dio.dart';
import 'package:koolbar_demo/core/network/api_response.dart';

class ClientHelper {
  late final Dio _dio;
  final Map<String, String> _headers = {};

  ClientHelper.connect(String baseUrl, [Map<String, String>? header]) {
    if (header != null) _headers.addAll(header);
    _dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        headers: _headers,
        connectTimeout: Duration(seconds: 4),
        sendTimeout: Duration(seconds: 4),
        receiveTimeout: Duration(seconds: 4),
      ),
    );
  }
  Future<Response<dynamic>> get(String path,[Object? data]) async {
    final res = await _dio.get(path,data: data);
    if(res.statusCode!=200)
      throw res.statusMessage??"";
    return res;
  }

  Future<Response> post(String path,[Object? data]) async {
    final res = await _dio.post(path,data: data);
    return res;
  }
}
