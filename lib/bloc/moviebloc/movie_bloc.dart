import 'package:cinem_app/bloc/moviebloc/movie_bloc_event.dart';
import 'package:cinem_app/bloc/moviebloc/movie_bloc_state.dart';
import 'package:cinem_app/model/movie.dart';
import 'package:cinem_app/service/api_service.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieBloc extends Bloc<MovieEvent, MovieState> {
  MovieBloc() : super(MovieLoading());

  @override
  Stream<MovieState> mapEventToState(MovieEvent event) async* {
    if (event is MovieEventStarted) {
      yield* _mapMovieEventStateToState(event.movieId, event.query);
    }
  }

  Stream<MovieState> _mapMovieEventStateToState(
      int movieId, String query) async* {
    final service = ApiService();
    yield MovieLoading();
    try {
      List<Movie>? movieList;
      if (movieId == 0) {
        movieList = await service.getNowPlayingMovie();
      }

      yield MovieLoaded(movieList!);
    } on Exception catch (e) {
      print(e);
      yield MovieError();
    }
  }
}
