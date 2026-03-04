import 'package:ditonton/domain/usecases/movies/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/movies/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/movies/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/movie/movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/movie_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NowPlayingMovieBloc extends Bloc<MovieEvent, MovieState> {
  final GetNowPlayingMovies _getNowPlayingMovies;

  NowPlayingMovieBloc(this._getNowPlayingMovies) : super(MovieEmpty()) {
    on<FetchNowPlayingMovies>((event, emit) async {
      emit(MovieLoading());
      final result = await _getNowPlayingMovies.execute();
      result.fold(
        (failure) => emit(MovieError(failure.message)),
        (data) => emit(MovieHasData(data)),
      );
    });
  }
}

class PopularMovieBloc extends Bloc<MovieEvent, MovieState> {
  final GetPopularMovies _getPopularMovies;

  PopularMovieBloc(this._getPopularMovies) : super(MovieEmpty()) {
    on<FetchPopularMovies>((event, emit) async {
      emit(MovieLoading());
      final result = await _getPopularMovies.execute();
      result.fold(
        (failure) => emit(MovieError(failure.message)),
        (data) => emit(MovieHasData(data)),
      );
    });
  }
}

class TopRatedMovieBloc extends Bloc<MovieEvent, MovieState> {
  final GetTopRatedMovies _getTopRatedMovies;

  TopRatedMovieBloc(this._getTopRatedMovies) : super(MovieEmpty()) {
    on<FetchTopRatedMovies>((event, emit) async {
      emit(MovieLoading());
      final result = await _getTopRatedMovies.execute();
      result.fold(
        (failure) => emit(MovieError(failure.message)),
        (data) => emit(MovieHasData(data)),
      );
    });
  }
}
