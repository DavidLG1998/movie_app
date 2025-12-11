import 'package:flutter/material.dart';
import 'package:appmovie/services/api_services.dart';
import 'package:appmovie/models/movie_detail_model.dart';
import 'package:appmovie/models/cast_model.dart';
import 'package:appmovie/ui/widgets/item_cast_widget.dart';
import 'package:appmovie/ui/widgets/title_description_widget.dart';

class MovieDetailPage extends StatefulWidget {
  final int movieId;

  const MovieDetailPage({Key? key, required this.movieId}) : super(key: key);

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final APIServices _apiServices = APIServices();

  MovieDetailModel? _movieDetail;
  List<Cast> _castList = [];

  bool _isLoadingDetail = true;
  bool _isLoadingCast = true;

  @override
  void initState() {
    super.initState();
    _loadDetail();
    _loadCast();
  }

  Future<void> _loadDetail() async {
    try {
      final detail = await _apiServices.getMovieDetail(widget.movieId);
      setState(() {
        _movieDetail = detail;
        _isLoadingDetail = false;
      });
    } catch (_) {
      setState(() {
        _movieDetail = null;
        _isLoadingDetail = false;
      });
    }
  }

  Future<void> _loadCast() async {
    try {
      final cast = await _apiServices.getMovieCredits(widget.movieId);
      setState(() {
        _castList = cast;
        _isLoadingCast = false;
      });
    } catch (_) {
      setState(() {
        _castList = [];
        _isLoadingCast = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final title = _movieDetail?.title ?? 'Detalle';
    final posterPath = _movieDetail?.posterPath ?? '';
    final backdropPath = _movieDetail?.backdropPath ?? '';

    return Scaffold(
      backgroundColor: const Color(0xff161823),
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(title),
      ),
      body: _isLoadingDetail
          ? const Center(child: CircularProgressIndicator())
          : _movieDetail == null
          ? const Center(
        child: Text(
          'No se pudo cargar el detalle de la película.',
          style: TextStyle(color: Colors.white),
        ),
      )
          : SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _HeaderImage(
              backdropPath: backdropPath,
              posterPath: posterPath,
              title: title,
            ),
            const SizedBox(height: 16),

            TitleDescriptionWidget(
              title: "Sinopsis",
              description: _movieDetail!.overview,
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: TitleDescriptionWidget(
                    title: "Fecha de estreno",
                    description:
                    _formatDate(_movieDetail!.releaseDate),
                  ),
                ),
                Expanded(
                  child: TitleDescriptionWidget(
                    title: "Rating",
                    description:
                    "${_movieDetail!.voteAverage.toStringAsFixed(1)} / 10",
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            if (_movieDetail!.genres.isNotEmpty) ...[
              const Text(
                "Géneros",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _movieDetail!.genres
                    .map(
                      (g) => Chip(
                    label: Text(g.name),
                    backgroundColor: const Color(0xff1E1F2E),
                    labelStyle:
                    const TextStyle(color: Colors.white),
                    side: const BorderSide(
                        color: Colors.white24, width: 0.5),
                  ),
                )
                    .toList(),
              ),
              const SizedBox(height: 16),
            ],

            const Text(
              "Reparto",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            SizedBox(
              height: 140,
              child: _isLoadingCast
                  ? const Center(child: CircularProgressIndicator())
                  : _castList.isEmpty
                  ? const Center(
                child: Text(
                  "No hay información de reparto.",
                  style: TextStyle(color: Colors.white70),
                ),
              )
                  : ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: _castList.length,
                itemBuilder: (context, index) {
                  return ItemCastWidget(
                    cast: _castList[index],
                  );
                },
              ),
            ),

            const SizedBox(height: 24),

            if (_movieDetail!.productionCompanies.isNotEmpty) ...[
              const Text(
                "Productoras",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _movieDetail!.productionCompanies
                    .map(
                      (pc) => Chip(
                    label: Text(pc.name),
                    backgroundColor: const Color(0xff1E1F2E),
                    labelStyle:
                    const TextStyle(color: Colors.white),
                    side: const BorderSide(
                        color: Colors.white24, width: 0.5),
                  ),
                )
                    .toList(),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return "$d/$m/$y";
  }
}

class _HeaderImage extends StatelessWidget {
  final String backdropPath;
  final String posterPath;
  final String title;

  const _HeaderImage({
    Key? key,
    required this.backdropPath,
    required this.posterPath,
    required this.title,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Stack(
        fit: StackFit.expand,
        children: [
          if (backdropPath.isNotEmpty)
            Image.network(
              "https://image.tmdb.org/t/p/w780$backdropPath",
              fit: BoxFit.cover,
            )
          else if (posterPath.isNotEmpty)
            Image.network(
              "https://image.tmdb.org/t/p/w500$posterPath",
              fit: BoxFit.cover,
            )
          else
            Container(
              color: const Color(0xff1E1F2E),
              child: const Icon(Icons.movie, color: Colors.grey, size: 48),
            ),
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
          Positioned(
            left: 16,
            bottom: 12,
            right: 16,
            child: Text(
              title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

