import 'package:dio/dio.dart';
import 'package:order_food_mobile/core/service/dio_error_handler.dart';
import 'package:order_food_mobile/core/service/http_request.dart';
import 'package:order_food_mobile/core/utilities/response_mapper.dart';
import 'package:order_food_mobile/models/menu.dart';

class MenuServices {
  Future<List<Menu>> getMenu([Map<String, dynamic>? params]) async {
    try {
      final response = await HttpRequest.get('/menus', query: params);

      return responseMapper(
        response,
        (data) => (data as List).map((e) => Menu.fromJson(e)).toList(),
      );
    } on DioException catch (e) {
      final message = DioErrorHandler.handle(
        e,
        fallback: 'Gagal mendapatkan Menu',
      );
      throw Exception(message);
    }
  }
}
