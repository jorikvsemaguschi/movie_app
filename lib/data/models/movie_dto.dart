import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/movie.dart';

part 'movie_dto.freezed.dart';
part 'movie_dto.g.dart';

@freezed
class MovieDto with _$MovieDto {
  factory MovieDto({
    required String id,
    required String title,
    String? overview,
    @JsonKey(name: 'poster_path') String? posterPath,
  }) = _MovieDto;

  factory MovieDto.fromJson(Map<String, dynamic> json) => _$MovieDtoFromJson(json);
}

extension MovieMapper on MovieDto {
  Movie toEntity() {
    return Movie(
      id: id,
      title: title,
      overview: overview,
      posterUrl: posterPath != null && posterPath!.isNotEmpty
          ? (posterPath!.startsWith('http') ? posterPath : 'https://image.tmdb.org/t/p/w500$posterPath')
          : null,
    );
  }
}