import 'package:dio/dio.dart';
import 'package:order_food_mobile/core/service/dio_error_handler.dart';
import 'package:order_food_mobile/core/service/http_request.dart';
import 'package:order_food_mobile/models/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  Future<String> login(String email, String password) async {
    try {
      final response = await HttpRequest.post(
        '/login',
        data: {"email": email, "password": password},
      );

      final token = response.data['token'];

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", token);

      return 'success';
    } on DioException catch (e) {
      return DioErrorHandler.handle(e, fallback: 'Login Gagal');
    } catch (e) {
      return 'Terjadi kesalahan tak terduga, Coba Lagi.';
    }
  }

  Future<String> logout() async {
    try {
      final response = await HttpRequest.get('/logout');

      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.remove('token');
        return 'success';
      }

      return 'Gagal Hapus Data. Code ${response.statusCode}';
    } on DioException catch (e) {
      return DioErrorHandler.handle(e, fallback: 'Gagal Logout');
    } catch (e) {
      return 'Terjadi kesalahan tak terduga, Coba Lagi.';
    }
  }

  Future<User> getProfile() async {
    try {
      final response = await HttpRequest.get('/me');
      return User.fromJson(response.data);
    } on DioException catch (e) {
      final message = DioErrorHandler.handle(e, fallback: 'Gagal mendapatkan profile');
      throw Exception(message);
    } catch (e) {
      throw Exception('Tidak ada koneksi internet');
    }
  }
}
