import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_movies.dart';
import 'movie_list_event.dart';
import 'movie_list_state.dart';
import '../../core/logger.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetMovies getMovies;

  MovieListBloc(this.getMovies) : super(MovieListInitial()) {
    on<LoadMovies>(_onLoadMovies);
  }

  Future<void> _onLoadMovies(LoadMovies event, Emitter<MovieListState> emit) async {
    emit(MovieListLoading());
    try {
      logger.i('BLoC: load movies, source=${event.source}');
      final movies = await getMovies(
        forceRefresh: event.forceRefresh,
        source: event.source,
      );
      emit(MovieListLoaded(movies));
    } catch (e, st) {
      logger.e('BLoC error', error: e, stackTrace: st);
      emit(MovieListError(e.toString()));
    }
  }
}