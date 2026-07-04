T responseMapper<T>(
  dynamic response,
  T Function(dynamic data) mapper,
) {
  return mapper(response.data['data']);
}