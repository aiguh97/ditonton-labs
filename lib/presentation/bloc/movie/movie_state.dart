import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:equatable/equatable.dart';

abstract class MovieState extends Equatable {
  const MovieState();

  @override
  List<Object> get props => [];
}

class MovieEmpty extends MovieState {}

class MovieLoading extends MovieState {}

class MovieHasData extends MovieState {
  final List<Movie> result;

  const MovieHasData(this.result);

  @override
  List<Object> get props => [result];
}

class MovieDetailHasData extends MovieState {
  final MovieDetail result;

  const MovieDetailHasData(this.result);

  @override
  List<Object> get props => [result];
}

class MovieError extends MovieState {
  final String message;

  const MovieError(this.message);

  @override
  List<Object> get props => [message];
}
