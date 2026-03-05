import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/tv_series/get_watchlist_status_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/save_watchlist_tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tv_series_detail_event.dart';
part 'tv_series_detail_state.dart';

class TvSeriesDetailBloc
    extends Bloc<TvSeriesDetailEvent, TvSeriesDetailState> {
  static const String watchlistAddSuccessMessage = 'Added to Watchlist';
  static const String watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvSeriesDetail getTvSeriesDetail;
  final GetTvSeriesRecommendations getTvSeriesRecommendations;
  final GetWatchListStatusTvSeries getWatchListStatusTvSeries;
  final SaveWatchlistTvSeries saveWatchlistTvSeries;
  final RemoveWatchlistTvSeries removeWatchlistTvSeries;

  TvSeriesDetail? _tvSeriesDetail;
  List<TvSeries> _recommendations = [];
  bool _isAddedToWatchlist = false;

  TvSeriesDetailBloc({
    required this.getTvSeriesDetail,
    required this.getTvSeriesRecommendations,
    required this.getWatchListStatusTvSeries,
    required this.saveWatchlistTvSeries,
    required this.removeWatchlistTvSeries,
  }) : super(const TvSeriesDetailInitial()) {
    on<FetchTvSeriesDetailEvent>(_onFetchTvSeriesDetail);
    on<AddTvSeriesToWatchlistEvent>(_onAddTvSeriesToWatchlist);
    on<RemoveTvSeriesFromWatchlistEvent>(_onRemoveTvSeriesFromWatchlist);
    on<LoadTvSeriesWatchlistStatusEvent>(_onLoadTvSeriesWatchlistStatus);
  }

  Future<void> _onFetchTvSeriesDetail(
    FetchTvSeriesDetailEvent event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    emit(const TvSeriesDetailLoading());
    final detailResult = await getTvSeriesDetail.execute(event.id);
    if (detailResult.isLeft()) {
      detailResult.fold(
        (failure) => emit(TvSeriesDetailError(failure.message)),
        (_) {},
      );
      return;
    }

    late TvSeriesDetail tvSeries;
    detailResult.fold((_) {}, (t) => tvSeries = t);

    final recommendationResult = await getTvSeriesRecommendations.execute(
      event.id,
    );
    recommendationResult.fold(
      (failure) {
        _recommendations = [];
      },
      (recommendations) {
        _recommendations = recommendations;
      },
    );

    _tvSeriesDetail = tvSeries;
    await _loadWatchlistStatus(event.id, emit);
  }

  Future<void> _onAddTvSeriesToWatchlist(
    AddTvSeriesToWatchlistEvent event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    final result = await saveWatchlistTvSeries.execute(event.tvSeries);

    String watchlistMessage = '';
    result.fold(
      (failure) {
        watchlistMessage = failure.message;
      },
      (successMessage) {
        watchlistMessage = successMessage;
      },
    );

    await _loadWatchlistStatus(event.tvSeries.id, emit);

    final currentState = state;
    if ((currentState is TvSeriesDetailLoaded ||
            currentState is TvSeriesDetailWatchlistUpdated) &&
        _tvSeriesDetail != null) {
      if (emit.isDone) return;
      emit(
        TvSeriesDetailWatchlistUpdated(
          tvSeries: _tvSeriesDetail!,
          recommendations: _recommendations,
          isAddedToWatchlist: _isAddedToWatchlist,
          watchlistMessage: watchlistMessage,
        ),
      );
    }
  }

  Future<void> _onRemoveTvSeriesFromWatchlist(
    RemoveTvSeriesFromWatchlistEvent event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    final result = await removeWatchlistTvSeries.execute(event.tvSeries);

    String watchlistMessage = '';
    result.fold(
      (failure) {
        watchlistMessage = failure.message;
      },
      (successMessage) {
        watchlistMessage = successMessage;
      },
    );

    await _loadWatchlistStatus(event.tvSeries.id, emit);

    final currentState = state;
    if ((currentState is TvSeriesDetailLoaded ||
            currentState is TvSeriesDetailWatchlistUpdated) &&
        _tvSeriesDetail != null) {
      if (emit.isDone) return;
      emit(
        TvSeriesDetailWatchlistUpdated(
          tvSeries: _tvSeriesDetail!,
          recommendations: _recommendations,
          isAddedToWatchlist: _isAddedToWatchlist,
          watchlistMessage: watchlistMessage,
        ),
      );
    }
  }

  Future<void> _onLoadTvSeriesWatchlistStatus(
    LoadTvSeriesWatchlistStatusEvent event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    await _loadWatchlistStatus(event.id, emit);
  }

  Future<void> _loadWatchlistStatus(
    int id,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    final result = await getWatchListStatusTvSeries.execute(id);
    _isAddedToWatchlist = result;
    if (emit.isDone) return;

    if (_tvSeriesDetail == null) {
      if (!emit.isDone)
        emit(const TvSeriesDetailError('Tv series detail not loaded'));
      return;
    }

    if (!emit.isDone) {
      emit(
        TvSeriesDetailLoaded(
          tvSeries: _tvSeriesDetail!,
          recommendations: _recommendations,
          isAddedToWatchlist: _isAddedToWatchlist,
        ),
      );
    }
  }
}
