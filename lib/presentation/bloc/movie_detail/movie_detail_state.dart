import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';

abstract class MovieDetailState {}

class MovieDetailEmpty extends MovieDetailState {}

class MovieDetailLoading extends MovieDetailState {}

class MovieDetailLoaded extends MovieDetailState {
  final MovieDetail movie;
  final List<Movie> recommendations;

  MovieDetailLoaded(this.movie, this.recommendations);
}

class WatchlistStatusLoaded extends MovieDetailState {
  final bool isAdded;

  WatchlistStatusLoaded(this.isAdded);
}

class MovieDetailError extends MovieDetailState {
  final String message;

  MovieDetailError(this.message);
}
