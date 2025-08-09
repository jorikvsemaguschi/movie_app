import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dio/dio.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'core/logger.dart';
import 'data/datasources/movie_local_cache.dart';
import 'data/datasources/movie_remote_graphql.dart';
import 'data/datasources/movie_remote_rest.dart';
import 'data/repositories/movie_repository_impl.dart';
import 'domain/usecases/get_movies.dart';
import 'presentation/bloc/movie_list_bloc.dart';
import 'presentation/pages/movie_list_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isWindows) {
    final dir = await getApplicationSupportDirectory();
    Hive.init(dir.path);
  }
  await initHiveForFlutter();

  final dio = Dio();
  dio.interceptors.add(LogInterceptor(requestBody: false, responseBody: false));

  const tmdbApiKey = String.fromEnvironment('0c7b0f83fdfc418ac0f28c736b698422', defaultValue: '0c7b0f83fdfc418ac0f28c736b698422');

  final restDatasource = MovieRemoteRestDatasource(dio: dio, apiKey: tmdbApiKey);

  final httpLink = HttpLink('https://swapi-graphql.netlify.app/.netlify/functions/index');
  final graphQLClient = GraphQLClient(link: httpLink, cache: GraphQLCache(store: InMemoryStore()));
  final graphqlDatasource = MovieRemoteGraphQLDatasource(client: graphQLClient);

  final cacheDatasource = MovieLocalCacheDatasource();

  final repository = MovieRepositoryImpl(
    restDatasource: restDatasource,
    graphqlDatasource: graphqlDatasource,
    cacheDatasource: cacheDatasource,
  );

  final getMovies = GetMovies(repository);

  runApp(MyApp(getMovies: getMovies));
}

class MyApp extends StatelessWidget {
  final GetMovies getMovies;
  const MyApp({Key? key, required this.getMovies}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: BlocProvider(
        create: (_) => MovieListBloc(getMovies),
        child: const MovieListPage(),
      ),
    );
  }
}

