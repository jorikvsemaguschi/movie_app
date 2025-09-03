import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetMovies {
  final IMovieRepository repository;
  GetMovies(this.repository);

  /// Получает список фильмов через репозиторий.
  Future<List<Movie>> call({
    bool forceRefresh = false,
    SourceType source = SourceType.rest,
  }) {
    return repository.getMovies(forceRefresh: forceRefresh, source: source);
  }
}