import 'package:dio/dio.dart';
import 'package:order_food_mobile/core/configs/app_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HttpRequest {
  static final Dio _dio = Dio(
    BaseOptions(
      baseUrl: AppConfig.apiUrl,
      headers: {
        "Accept": "application/json",
      },
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  )..interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final prefs = await SharedPreferences.getInstance();
          final token = prefs.getString('token');
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }

          if (options.data is FormData) {
            options.headers['Content-Type'] = 'multipart/form-data';
          } else {
            options.headers['Content-Type'] = 'application/json';
          }

          return handler.next(options);
        },
      ),
    );

  static Future<Response> get(String path, {Map<String, dynamic>? query}) {
    return _dio.get(path, queryParameters: query);
  }

  static Future<Response> post(String path, {dynamic data}) {
    return _dio.post(path, data: data);
  }

  static Future<Response> put(String path, {dynamic data}) {
    return _dio.put(path, data: data);
  }

  static Future<Response> patch(String path, {dynamic data}) {
    return _dio.patch(path, data: data);
  }

  static Future<Response> delete(String path, {dynamic data}) {
    return _dio.delete(path, data: data);
  }
}