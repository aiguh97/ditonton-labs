import 'package:ditonton/domain/entities/movie_detail.dart';

abstract class MovieDetailEvent {}

class FetchMovieDetailEvent extends MovieDetailEvent {
  final int id;

  FetchMovieDetailEvent(this.id);
}

class FetchMovieRecommendationsEvent extends MovieDetailEvent {
  final int id;

  FetchMovieRecommendationsEvent(this.id);
}

class AddWatchlistEvent extends MovieDetailEvent {
  final MovieDetail movie;

  AddWatchlistEvent(this.movie);
}

class RemoveWatchlistEvent extends MovieDetailEvent {
  final MovieDetail movie;

  RemoveWatchlistEvent(this.movie);
}

class LoadWatchlistStatusEvent extends MovieDetailEvent {
  final int id;

  LoadWatchlistStatusEvent(this.id);
}
