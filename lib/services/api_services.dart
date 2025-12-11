import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/movie_models.dart';
import '../models/movie_detail_model.dart';
import '../models/cast_model.dart';
import '../ui/utils/constants.dart';

class APIServices {
  /// Obtiene la lista de películas populares/descubiertas
  Future<List<MovieModel>> getMovies() async {
    try {
      final uri = Uri.parse(
          "$pathProduction/discover/movie?api_key=$apiKey&language=es-ES");
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final myMap = json.decode(response.body);
        final List<dynamic> movies = myMap["results"];
        return movies.map((e) => MovieModel.fromJson(e)).toList();
      }
    } catch (e) {
      print("Error en getMovies: $e");
    }
    return [];
  }

  /// Obtiene el detalle de una película por su ID
  Future<MovieDetailModel?> getMovieDetail(int movieId) async {
    try {
      final uri = Uri.parse(
          "$pathProduction/movie/$movieId?api_key=$apiKey&language=es-ES");
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final myMap = json.decode(response.body);
        return MovieDetailModel.fromJson(myMap);
      }
    } catch (e) {
      print("Error en getMovieDetail: $e");
    }
    return null;
  }

  /// Obtiene el reparto (cast) de una película por su ID
  Future<List<Cast>> getMovieCredits(int movieId) async {
    try {
      final uri = Uri.parse(
          "$pathProduction/movie/$movieId/credits?api_key=$apiKey&language=es-ES");
      final response = await http.get(uri);

      if (response.statusCode == 200) {
        final myMap = json.decode(response.body);
        final List<dynamic> castList = myMap["cast"];
        return castList.map((e) => Cast.fromJson(e)).toList();
      }
    } catch (e) {
      print("Error en getMovieCredits: $e");
    }
    return [];
  }
}



