import 'dart:io';

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

  Future<Menu> getDetailMenu(int id) async {
    try {
      final response = await HttpRequest.get('/menus/$id');

      return responseMapper(response, (data) => Menu.fromJson(data));
    } on DioException catch (e) {
      final message = DioErrorHandler.handle(
        e,
        fallback: 'Gagal mendapatkan detail menu',
      );
      throw Exception(message);
    }
  }

  Future<Menu> createMenu({
    required String name,
    required String description,
    required int price,
    required String category,
    required File image
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': name,
        'description': description,
        'price': price,
        'category': category,
        'image': await MultipartFile.fromFile(
          image.path,
          filename: image.path.split('/').last,
        ),
      });

      final response = await HttpRequest.post('/menus', data: formData);

      return responseMapper(response, (data) => Menu.fromJson(data));
    } on DioException catch (e) {
      final message = DioErrorHandler.handle(e, fallback: 'Gagal menambah menu');
      throw Exception(message);
    }
  }

  Future<Menu> updateMenu({
    required int id,
    required String name,
    required String description,
    required int price,
    required String category,
    File? image,
  }) async {
    try {
      final formData = FormData.fromMap({
        'name': name,
        'description': description,
        'price': price,
        'category': category,
        '_method': 'PATCH',
        if (image != null)
          'image': await MultipartFile.fromFile(
            image.path,
            filename: image.path.split('/').last,
          ),
      });

      final response = await HttpRequest.post('/menus/$id', data: formData);

      return responseMapper(response, (data) => Menu.fromJson(data));
    } on DioException catch (e) {
      final message = DioErrorHandler.handle(e, fallback: 'Gagal update menu');
      throw Exception(message);
    }
  }

  Future<void> deleteMenu(int id) async {
    try {
      await HttpRequest.delete('/menus/$id');
    } on DioException catch (e) {
      final message = DioErrorHandler.handle(
        e,
        fallback: 'Gagal Menghapus Menu',
      );
      throw Exception(message);
    }
  }
}
