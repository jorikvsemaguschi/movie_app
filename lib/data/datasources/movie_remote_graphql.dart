import 'package:graphql_flutter/graphql_flutter.dart';
import '../models/movie_dto.dart';
import '../../core/logger.dart';

class MovieRemoteGraphQLDatasource {
  final GraphQLClient client;

  MovieRemoteGraphQLDatasource({required this.client});

  Future<List<MovieDto>> fetchMovies() async {
    logger.i('GraphQL: Fetching movies (SWAPI)...');
    const query = r'''
      query {
        allFilms {
          films {
            id
            title
            openingCrawl
          }
        }
      }
    ''';

    final result = await client.query(QueryOptions(document: gql(query)));
    if (result.hasException) {
      logger.e('GraphQL error', error: result.exception);
      throw Exception(result.exception.toString());
    }

    final List data = result.data?['allFilms']?['films'] ?? [];
    return data.map((json) {
      final mapped = <String, dynamic>{
        'id': json['id'].toString(),
        'title': json['title'] ?? 'No title',
        'overview': json['openingCrawl'] ?? '',
        'poster_path': null,
      };
      return MovieDto.fromJson(mapped);
    }).toList();
  }
}