import 'package:dio/dio.dart';
import '../models/movie_dto.dart';
import '../../core/logger.dart';

class MovieRemoteRestDatasource {
  final Dio dio;
  final String apiKey;

  MovieRemoteRestDatasource({required this.dio, required this.apiKey});

  /// Получает список популярных фильмов из TMDB REST API.
  Future<List<MovieDto>> fetchMovies() async {
    logger.i('REST: Fetching movies...');
    final response = await dio.get(
      'https://api.themoviedb.org/3/movie/popular',
      queryParameters: {'api_key': apiKey, 'language': 'en-US', 'page': 1},
    );
    final List results = response.data['results'] as List;
    return results.map((json) {
      final mapped = Map<String, dynamic>.from(json);
      mapped['id'] = json['id'].toString();
      return MovieDto.fromJson(mapped);
    }).toList();
  }
}