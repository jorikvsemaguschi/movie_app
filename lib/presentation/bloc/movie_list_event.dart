import '../../domain/repositories/movie_repository.dart';

abstract class MovieListEvent {}

class LoadMovies extends MovieListEvent {
  final SourceType source;
  final bool forceRefresh;
  LoadMovies({this.source = SourceType.rest, this.forceRefresh = false});
}