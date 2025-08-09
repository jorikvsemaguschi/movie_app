import '../entities/movie.dart';

enum SourceType { rest, graphql }

abstract class IMovieRepository {
  Future<List<Movie>> getMovies({
    bool forceRefresh = false,
    SourceType source = SourceType.rest,
  });
}