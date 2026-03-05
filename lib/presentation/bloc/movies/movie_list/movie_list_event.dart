part of 'movie_list_bloc.dart';

abstract class MovieListEvent extends Equatable {
  const MovieListEvent();

  @override
  List<Object> get props => [];
}

class FetchNowPlayingMoviesEvent extends MovieListEvent {
  const FetchNowPlayingMoviesEvent();
}

class FetchPopularMoviesEvent extends MovieListEvent {
  const FetchPopularMoviesEvent();
}

class FetchTopRatedMoviesEvent extends MovieListEvent {
  const FetchTopRatedMoviesEvent();
}
