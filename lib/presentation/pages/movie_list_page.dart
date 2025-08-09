import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/movie_list_bloc.dart';
import '../bloc/movie_list_event.dart';
import '../bloc/movie_list_state.dart';
import '../widgets/movie_item.dart';
import '../../domain/repositories/movie_repository.dart';

class MovieListPage extends StatefulWidget {
  const MovieListPage({Key? key}) : super(key: key);

  @override
  State<MovieListPage> createState() => _MovieListPageState();
}

class _MovieListPageState extends State<MovieListPage> {
  SourceType _source = SourceType.rest;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<MovieListBloc>().add(LoadMovies(source: _source));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Фильмы'),
        actions: [
          PopupMenuButton<SourceType>(
            onSelected: (v) {
              setState(() => _source = v);
              context.read<MovieListBloc>().add(LoadMovies(source: _source, forceRefresh: true));
            },
            itemBuilder: (c) => [
              PopupMenuItem(value: SourceType.rest, child: Row(children: const [Icon(Icons.http), SizedBox(width: 8), Text('REST (TMDB)')])),
              PopupMenuItem(value: SourceType.graphql, child: Row(children: const [Icon(Icons.graphic_eq), SizedBox(width: 8), Text('GraphQL (SWAPI)')])),
            ],
            icon: const Icon(Icons.cloud_done),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          context.read<MovieListBloc>().add(LoadMovies(source: _source, forceRefresh: true));
        },
        child: BlocBuilder<MovieListBloc, MovieListState>(
          builder: (context, state) {
            if (state is MovieListLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is MovieListLoaded) {
              if (state.movies.isEmpty) {
                return const Center(child: Text('No movies found'));
              }
              return ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                itemCount: state.movies.length,
                itemBuilder: (context, index) => MovieItem(movie: state.movies[index]),
              );
            } else if (state is MovieListError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            return Center(
              child: ElevatedButton(
                onPressed: () {
                  context.read<MovieListBloc>().add(LoadMovies(source: _source));
                },
                child: const Text('Load movies'),
              ),
            );
          },
        ),
      ),
    );
  }
}