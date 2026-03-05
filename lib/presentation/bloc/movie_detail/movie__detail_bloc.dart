import 'package:ditonton/domain/usecases/movies/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/movies/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/movies/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/movies/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/movies/save_watchlist.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_event.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  MovieDetailBloc(
    this.getMovieDetail,
    this.getMovieRecommendations,
    this.getWatchListStatus,
    this.saveWatchlist,
    this.removeWatchlist,
  ) : super(MovieDetailEmpty()) {
    on<FetchMovieDetailEvent>(_onFetchDetail);
    on<AddWatchlistEvent>(_onAddWatchlist);
    on<RemoveWatchlistEvent>(_onRemoveWatchlist);
    on<LoadWatchlistStatusEvent>(_onLoadStatus);
  }

  Future<void> _onFetchDetail(
    FetchMovieDetailEvent event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(MovieDetailLoading());

    final detailResult = await getMovieDetail.execute(event.id);

    final recommendationResult = await getMovieRecommendations.execute(
      event.id,
    );

    detailResult.fold((failure) => emit(MovieDetailError(failure.message)), (
      movie,
    ) async {
      recommendationResult.fold(
        (failure) => emit(MovieDetailError(failure.message)),
        (recommendations) => emit(MovieDetailLoaded(movie, recommendations)),
      );
    });
  }

  Future<void> _onAddWatchlist(
    AddWatchlistEvent event,
    Emitter<MovieDetailState> emit,
  ) async {
    await saveWatchlist.execute(event.movie);
    add(LoadWatchlistStatusEvent(event.movie.id));
  }

  Future<void> _onRemoveWatchlist(
    RemoveWatchlistEvent event,
    Emitter<MovieDetailState> emit,
  ) async {
    await removeWatchlist.execute(event.movie);
    add(LoadWatchlistStatusEvent(event.movie.id));
  }

  Future<void> _onLoadStatus(
    LoadWatchlistStatusEvent event,
    Emitter<MovieDetailState> emit,
  ) async {
    final result = await getWatchListStatus.execute(event.id);

    emit(WatchlistStatusLoaded(result));
  }
}
