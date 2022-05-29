import 'package:cinem_app/model/movie.dart';
import 'package:dio/dio.dart';

class ApiService {
  final Dio _dio = Dio();

  String? accessToken;

  final String baseUrl = 'https://api.themoviedb.org/3';
  final String apiKey = '6e381b492899070fe4fc5fac0c0c8af6';

  Future<List<Movie>> getNowPlayingMovie() async {
    try {
      final url = '$baseUrl/movie/now_playing?$apiKey';
      final response = await _dio.get(url);
      var movies = response.data['results'] as List;
      List<Movie> movieList = movies.map((m) => Movie.fromJson(m)).toList();
      return movieList;
    } catch (error, stacktrace) {
      print(error);
      throw Exception(
        'Exception occured: $error with stacktrace: $stacktrace',
      );
    }
  }
}
