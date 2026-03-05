import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/domain/usecases/movies/get_watchlist_movies.dart';
import 'package:ditonton/presentation/bloc/movie/movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/movie_state.dart';

class WatchlistMovieBloc extends Bloc<MovieEvent, MovieState> {
  final GetWatchlistMovies getWatchlistMovies;

  WatchlistMovieBloc(this.getWatchlistMovies) : super(MovieEmpty()) {
    on<FetchWatchlistMoviesEvent>((event, emit) async {
      emit(MovieLoading());

      final result = await getWatchlistMovies.execute();

      result.fold(
        (failure) => emit(MovieError(failure.message)),
        (data) => emit(MovieHasData(data)),
      );
    });
  }
}
