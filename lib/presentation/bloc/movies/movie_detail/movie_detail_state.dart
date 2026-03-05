part of 'movie_detail_bloc.dart';

abstract class MovieDetailState extends Equatable {
  const MovieDetailState();

  @override
  List<Object> get props => [];
}

class MovieDetailInitial extends MovieDetailState {
  const MovieDetailInitial();
}

class MovieDetailLoading extends MovieDetailState {
  const MovieDetailLoading();
}

class MovieDetailLoaded extends MovieDetailState {
  final MovieDetail movie;
  final List<Movie> recommendations;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  const MovieDetailLoaded({
    required this.movie,
    required this.recommendations,
    required this.isAddedToWatchlist,
    this.watchlistMessage = '',
  });

  @override
  List<Object> get props =>
      [movie, recommendations, isAddedToWatchlist, watchlistMessage];
}

class MovieDetailError extends MovieDetailState {
  final String message;

  const MovieDetailError(this.message);

  @override
  List<Object> get props => [message];
}

class MovieDetailWatchlistUpdated extends MovieDetailState {
  final MovieDetail movie;
  final List<Movie> recommendations;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  const MovieDetailWatchlistUpdated({
    required this.movie,
    required this.recommendations,
    required this.isAddedToWatchlist,
    required this.watchlistMessage,
  });

  @override
  List<Object> get props =>
      [movie, recommendations, isAddedToWatchlist, watchlistMessage];
}
