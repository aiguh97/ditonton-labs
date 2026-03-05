import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/usecases/movies/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/movies/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/movies/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/movies/remove_watchlist.dart';
import 'package:ditonton/domain/usecases/movies/save_watchlist.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'movie_detail_event.dart';
part 'movie_detail_state.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  static const String watchlistAddSuccessMessage = 'Added to Watchlist';
  static const String watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetMovieDetail getMovieDetail;
  final GetMovieRecommendations getMovieRecommendations;
  final GetWatchListStatus getWatchListStatus;
  final SaveWatchlist saveWatchlist;
  final RemoveWatchlist removeWatchlist;

  MovieDetail? _movieDetail;
  List<Movie> _recommendations = [];
  bool _isAddedToWatchlist = false;

  MovieDetailBloc({
    required this.getMovieDetail,
    required this.getMovieRecommendations,
    required this.getWatchListStatus,
    required this.saveWatchlist,
    required this.removeWatchlist,
  }) : super(const MovieDetailInitial()) {
    on<FetchMovieDetailEvent>(_onFetchMovieDetail);
    on<AddMovieToWatchlistEvent>(_onAddMovieToWatchlist);
    on<RemoveMovieFromWatchlistEvent>(_onRemoveMovieFromWatchlist);
    on<LoadMovieWatchlistStatusEvent>(_onLoadMovieWatchlistStatus);
  }

  Future<void> _onFetchMovieDetail(
    FetchMovieDetailEvent event,
    Emitter<MovieDetailState> emit,
  ) async {
    emit(const MovieDetailLoading());
    final detailResult = await getMovieDetail.execute(event.id);
    if (detailResult.isLeft()) {
      detailResult.fold((failure) => emit(MovieDetailError(failure.message)), (_) {});
      return;
    }

    // extract movie (safe because it's Right)
    late MovieDetail movie;
    detailResult.fold((_) {}, (m) => movie = m);

    final recommendationResult = await getMovieRecommendations.execute(event.id);
    recommendationResult.fold(
      (failure) {
        _recommendations = [];
      },
      (recommendations) {
        _recommendations = recommendations;
      },
    );

    _movieDetail = movie;
    await _loadWatchlistStatus(event.id, emit);
  }

  Future<void> _onAddMovieToWatchlist(
    AddMovieToWatchlistEvent event,
    Emitter<MovieDetailState> emit,
  ) async {
    final result = await saveWatchlist.execute(event.movie);

    String watchlistMessage = '';
    result.fold(
      (failure) {
        watchlistMessage = failure.message;
      },
      (successMessage) {
        watchlistMessage = successMessage;
      },
    );

    await _loadWatchlistStatus(event.movie.id, emit);

    final currentState = state;
    if (currentState is MovieDetailLoaded ||
        currentState is MovieDetailWatchlistUpdated) {
      if (emit.isDone) return;
      emit(
        MovieDetailWatchlistUpdated(
          movie: _movieDetail!,
          recommendations: _recommendations,
          isAddedToWatchlist: _isAddedToWatchlist,
          watchlistMessage: watchlistMessage,
        ),
      );
    }
  }

  Future<void> _onRemoveMovieFromWatchlist(
    RemoveMovieFromWatchlistEvent event,
    Emitter<MovieDetailState> emit,
  ) async {
    final result = await removeWatchlist.execute(event.movie);

    String watchlistMessage = '';
    result.fold(
      (failure) {
        watchlistMessage = failure.message;
      },
      (successMessage) {
        watchlistMessage = successMessage;
      },
    );

    await _loadWatchlistStatus(event.movie.id, emit);

    final currentState = state;
    if (currentState is MovieDetailLoaded ||
        currentState is MovieDetailWatchlistUpdated) {
      if (emit.isDone) return;
      emit(
        MovieDetailWatchlistUpdated(
          movie: _movieDetail!,
          recommendations: _recommendations,
          isAddedToWatchlist: _isAddedToWatchlist,
          watchlistMessage: watchlistMessage,
        ),
      );
    }
  }

  Future<void> _onLoadMovieWatchlistStatus(
    LoadMovieWatchlistStatusEvent event,
    Emitter<MovieDetailState> emit,
  ) async {
    await _loadWatchlistStatus(event.id, emit);
  }

  Future<void> _loadWatchlistStatus(
    int id,
    Emitter<MovieDetailState> emit,
  ) async {
    final result = await getWatchListStatus.execute(id);
    _isAddedToWatchlist = result;

    if (emit.isDone) return;

    if (_movieDetail == null) {
      if (!emit.isDone) emit(const MovieDetailError('Movie detail not loaded'));
      return;
    }

    if (!emit.isDone) {
      emit(
        MovieDetailLoaded(
          movie: _movieDetail!,
          recommendations: _recommendations,
          isAddedToWatchlist: _isAddedToWatchlist,
        ),
      );
    }
}

}

