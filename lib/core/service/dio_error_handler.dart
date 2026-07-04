import 'package:dio/dio.dart';

class DioErrorHandler {
  static String handle(DioException e, {String fallback = 'Terjadi kesalahan'}) {
    if (e.type == DioExceptionType.connectionTimeout ||
        e.type == DioExceptionType.receiveTimeout ||
        e.type == DioExceptionType.sendTimeout ||
        e.type == DioExceptionType.connectionError) {
      return 'Tidak ada koneksi internet';
    }

    if (e.type == DioExceptionType.cancel) {
      return 'Request dibatalkan';
    }

    if (e.response != null) {
      final data = e.response!.data;
      final statusCode = e.response!.statusCode;

      if (data is Map && data['message'] != null) {
        return data['message'];
      }

      switch (statusCode) {
        case 401:
          return 'Sesi habis, silakan login ulang';
        case 403:
          return 'Akses ditolak';
        case 404:
          return 'Data tidak ditemukan';
        case 500:
          return 'Server bermasalah, coba lagi nanti';
        default:
          return fallback;
      }
    }

    return fallback;
  }
}