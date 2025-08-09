import '../entities/movie.dart';
import '../repositories/movie_repository.dart';

class GetMovies {
  final IMovieRepository repository;
  GetMovies(this.repository);

  Future<List<Movie>> call({
    bool forceRefresh = false,
    SourceType source = SourceType.rest,
  }) {
    return repository.getMovies(forceRefresh: forceRefresh, source: source);
  }
}