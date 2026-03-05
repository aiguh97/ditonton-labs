import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/movies/get_now_playing_movies.dart';
import 'package:ditonton/domain/usecases/movies/get_popular_movies.dart';
import 'package:ditonton/domain/usecases/movies/get_top_rated_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'movie_list_event.dart';
part 'movie_list_state.dart';

class MovieListBloc extends Bloc<MovieListEvent, MovieListState> {
  final GetNowPlayingMovies getNowPlayingMovies;
  final GetPopularMovies getPopularMovies;
  final GetTopRatedMovies getTopRatedMovies;

  MovieListBloc({
    required this.getNowPlayingMovies,
    required this.getPopularMovies,
    required this.getTopRatedMovies,
  }) : super(const MovieListInitial()) {
    on<FetchNowPlayingMoviesEvent>(_onFetchNowPlayingMovies);
    on<FetchPopularMoviesEvent>(_onFetchPopularMovies);
    on<FetchTopRatedMoviesEvent>(_onFetchTopRatedMovies);
  }

  Future<void> _onFetchNowPlayingMovies(
    FetchNowPlayingMoviesEvent event,
    Emitter<MovieListState> emit,
  ) async {
    emit(const NowPlayingMoviesLoading());

    final result = await getNowPlayingMovies.execute();
    result.fold(
      (failure) => emit(NowPlayingMoviesError(failure.message)),
      (movies) => emit(NowPlayingMoviesLoaded(movies)),
    );
  }

  Future<void> _onFetchPopularMovies(
    FetchPopularMoviesEvent event,
    Emitter<MovieListState> emit,
  ) async {
    emit(const PopularMoviesLoading());

    final result = await getPopularMovies.execute();
    result.fold(
      (failure) => emit(PopularMoviesError(failure.message)),
      (movies) => emit(PopularMoviesLoaded(movies)),
    );
  }

  Future<void> _onFetchTopRatedMovies(
    FetchTopRatedMoviesEvent event,
    Emitter<MovieListState> emit,
  ) async {
    emit(const TopRatedMoviesLoading());

    final result = await getTopRatedMovies.execute();
    result.fold(
      (failure) => emit(TopRatedMoviesError(failure.message)),
      (movies) => emit(TopRatedMoviesLoaded(movies)),
    );
  }
}
