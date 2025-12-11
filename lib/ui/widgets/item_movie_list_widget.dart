import 'package:flutter/material.dart';
import '../../models/movie_models.dart';
import '../../pages/movie_detail_page.dart';

class ItemMovieListWidget extends StatelessWidget {
  final MovieModel movieModel;

  const ItemMovieListWidget({Key? key, required this.movieModel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => MovieDetailPage(movieId: movieModel.id),
          ),
        );
      },
      child: Card(
        color: const Color(0xff1E1F2E),
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        child: Row(
          children: [
            Image.network(
              "https://image.tmdb.org/t/p/w200${movieModel.posterPath}",
              width: 100,
              height: 150,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => const Icon(Icons.movie, size: 100, color: Colors.grey),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    movieModel.title,
                    style: const TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    movieModel.overview,
                    style: const TextStyle(color: Colors.grey, fontSize: 13),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    "⭐ ${movieModel.voteAverage.toString()}",
                    style: const TextStyle(color: Colors.amber, fontSize: 14),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
