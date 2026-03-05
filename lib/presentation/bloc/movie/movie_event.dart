import 'package:equatable/equatable.dart';

abstract class MovieEvent extends Equatable {
  const MovieEvent();

  @override
  List<Object> get props => [];
}

class FetchNowPlayingMovies extends MovieEvent {}

class FetchPopularMovies extends MovieEvent {}

class FetchTopRatedMovies extends MovieEvent {}

class FetchMovieDetail extends MovieEvent {
  final int id;

  const FetchMovieDetail(this.id);

  @override
  List<Object> get props => [id];
}

class FetchMovieRecommendations extends MovieEvent {
  final int id;

  const FetchMovieRecommendations(this.id);

  @override
  List<Object> get props => [id];
}
// ================= WATCHLIST =================

class FetchWatchlistMoviesEvent extends MovieEvent {}

class FetchPopularMoviesEvent extends MovieEvent {}

class SearchMoviesEvent extends MovieEvent {
  final String query;

  const SearchMoviesEvent(this.query);

  @override
  List<Object> get props => [query];
}
