import 'package:flutter/material.dart';
import '../../domain/entities/movie.dart';

class MovieItem extends StatelessWidget {
  final Movie movie;
  const MovieItem({Key? key, required this.movie}) : super(key: key);

  /// Строит виджет карточки фильма.
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(8),
        leading: movie.posterUrl != null
            ? ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.network(
            movie.posterUrl!,
            width: 60,
            height: 90,
            fit: BoxFit.cover,
            errorBuilder: (c, e, s) => const Icon(Icons.broken_image),
          ),
        )
            : const SizedBox(width: 60, child: Center(child: Icon(Icons.movie))),
        title: Text(movie.title, style: const TextStyle(fontWeight: FontWeight.w600)),
        subtitle: Text(
          movie.overview ?? '',
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
