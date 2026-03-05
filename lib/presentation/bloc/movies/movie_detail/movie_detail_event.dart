part of 'movie_detail_bloc.dart';

abstract class MovieDetailEvent extends Equatable {
  const MovieDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchMovieDetailEvent extends MovieDetailEvent {
  final int id;

  const FetchMovieDetailEvent(this.id);

  @override
  List<Object> get props => [id];
}

class AddMovieToWatchlistEvent extends MovieDetailEvent {
  final MovieDetail movie;

  const AddMovieToWatchlistEvent(this.movie);

  @override
  List<Object> get props => [movie];
}

class RemoveMovieFromWatchlistEvent extends MovieDetailEvent {
  final MovieDetail movie;

  const RemoveMovieFromWatchlistEvent(this.movie);

  @override
  List<Object> get props => [movie];
}

class LoadMovieWatchlistStatusEvent extends MovieDetailEvent {
  final int id;

  const LoadMovieWatchlistStatusEvent(this.id);

  @override
  List<Object> get props => [id];
}
