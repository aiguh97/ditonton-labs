import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/movies/get_watchlist_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'watchlist_movie_event.dart';
part 'watchlist_movie_state.dart';

class WatchlistMovieBloc
    extends Bloc<WatchlistMovieEvent, WatchlistMovieState> {
  final GetWatchlistMovies getWatchlistMovies;

  WatchlistMovieBloc({required this.getWatchlistMovies})
    : super(const WatchlistMovieInitial()) {
    on<FetchWatchlistMoviesEvent>(_onFetchWatchlistMovies);
  }

  Future<void> _onFetchWatchlistMovies(
    FetchWatchlistMoviesEvent event,
    Emitter<WatchlistMovieState> emit,
  ) async {
    emit(const WatchlistMovieLoading());

    final result = await getWatchlistMovies.execute();
    result.fold(
      (failure) => emit(WatchlistMovieError(failure.message)),
      (movies) => emit(WatchlistMovieLoaded(movies)),
    );
  }
}
