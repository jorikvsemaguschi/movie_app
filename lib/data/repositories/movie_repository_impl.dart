import '../../domain/entities/movie.dart';
import '../../domain/repositories/movie_repository.dart';
import '../datasources/movie_remote_rest.dart';
import '../datasources/movie_remote_graphql.dart';
import '../datasources/movie_local_cache.dart';
import '../models/movie_dto.dart';
import '../../core/logger.dart';

class MovieRepositoryImpl implements IMovieRepository {
  final MovieRemoteRestDatasource restDatasource;
  final MovieRemoteGraphQLDatasource graphqlDatasource;
  final MovieLocalCacheDatasource cacheDatasource;

  MovieRepositoryImpl({
    required this.restDatasource,
    required this.graphqlDatasource,
    required this.cacheDatasource,
  });

  /// Получает список фильмов из кэша или из выбранного источника (REST/GraphQL).
  @override
  Future<List<Movie>> getMovies({bool forceRefresh = false, SourceType source = SourceType.rest}) async {
    try {
      if (!forceRefresh) {
        final cached = await cacheDatasource.getMovies();
        if (cached != null && cached.isNotEmpty) {
          logger.i('Repository: return from cache');
          return cached.map((dto) => dto.toEntity()).toList();
        }
      }

      List<MovieDto> dtos;
      if (source == SourceType.rest) {
        dtos = await restDatasource.fetchMovies();
      } else {
        dtos = await graphqlDatasource.fetchMovies();
      }

      await cacheDatasource.saveMovies(dtos);
      return dtos.map((dto) => dto.toEntity()).toList();
    } catch (e, st) {
      logger.e('Repository error', error: e, stackTrace: st);
      final cached = await cacheDatasource.getMovies();
      if (cached != null && cached.isNotEmpty) {
        logger.w('Repository: fallback to cache');
        return cached.map((dto) => dto.toEntity()).toList();
      }
      rethrow;
    }
  }
}