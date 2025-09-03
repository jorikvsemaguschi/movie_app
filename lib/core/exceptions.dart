/// Исключение, возникающее при ошибке сервера.
class ServerException implements Exception {
  final String message;
  ServerException(this.message);
  @override
  String toString() => 'ServerException: $message';
}

/// Исключение, возникающее при ошибке кэша.
class CacheException implements Exception {
  final String message;
  CacheException(this.message);
  @override
  String toString() => 'CacheException: $message';
}