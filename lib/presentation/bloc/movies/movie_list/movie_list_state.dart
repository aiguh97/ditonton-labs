part of 'movie_list_bloc.dart';

abstract class MovieListState extends Equatable {
  const MovieListState();

  @override
  List<Object> get props => [];
}

class MovieListInitial extends MovieListState {
  const MovieListInitial();
}

class MovieListLoading extends MovieListState {
  const MovieListLoading();
}

class NowPlayingMoviesLoading extends MovieListState {
  const NowPlayingMoviesLoading();
}

class NowPlayingMoviesLoaded extends MovieListState {
  final List<Movie> movies;

  const NowPlayingMoviesLoaded(this.movies);

  @override
  List<Object> get props => [movies];
}

class NowPlayingMoviesError extends MovieListState {
  final String message;

  const NowPlayingMoviesError(this.message);

  @override
  List<Object> get props => [message];
}

class PopularMoviesLoading extends MovieListState {
  const PopularMoviesLoading();
}

class PopularMoviesLoaded extends MovieListState {
  final List<Movie> movies;

  const PopularMoviesLoaded(this.movies);

  @override
  List<Object> get props => [movies];
}

class PopularMoviesError extends MovieListState {
  final String message;

  const PopularMoviesError(this.message);

  @override
  List<Object> get props => [message];
}

class TopRatedMoviesLoading extends MovieListState {
  const TopRatedMoviesLoading();
}

class TopRatedMoviesLoaded extends MovieListState {
  final List<Movie> movies;

  const TopRatedMoviesLoaded(this.movies);

  @override
  List<Object> get props => [movies];
}

class TopRatedMoviesError extends MovieListState {
  final String message;

  const TopRatedMoviesError(this.message);

  @override
  List<Object> get props => [message];
}
