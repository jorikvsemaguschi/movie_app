import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/movie_dto.dart';
import '../../core/logger.dart';

class MovieLocalCacheDatasource {
  static const _cacheKey = 'movies_cache_v1';
  static const _cacheTsKey = 'movies_cache_ts_v1';

  /// Сохраняет список фильмов в локальный кэш.
  Future<void> saveMovies(List<MovieDto> movies) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonList = movies.map((m) => m.toJson()).toList();
    await prefs.setString(_cacheKey, jsonEncode(jsonList));
    await prefs.setInt(_cacheTsKey, DateTime.now().millisecondsSinceEpoch);
    logger.i('Cache: saved ${movies.length} movies');
  }

  /// Получает список фильмов из локального кэша, если он не устарел.
  Future<List<MovieDto>?> getMovies({Duration ttl = const Duration(hours: 1)}) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_cacheKey);
    if (jsonString == null) return null;
    final ts = prefs.getInt(_cacheTsKey) ?? 0;
    final cacheDate = DateTime.fromMillisecondsSinceEpoch(ts);
    final isExpired = DateTime.now().difference(cacheDate) > ttl;
    if (isExpired) {
      logger.i('Cache: expired');
      return null;
    }
    final List jsonList = jsonDecode(jsonString) as List;
    logger.i('Cache: loaded ${jsonList.length} movies');
    return jsonList.map((json) => MovieDto.fromJson(Map<String, dynamic>.from(json))).toList();
  }
}