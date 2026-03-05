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

class TvSeriesDetailBloc extends Bloc<TvSeriesDetailEvent, TvSeriesDetailState> {
  static const String watchlistAddSuccessMessage = 'Added to Watchlist';
  static const String watchlistRemoveSuccessMessage = 'Removed from Watchlist';

  final GetTvSeriesDetail getTvSeriesDetail;
  final GetTvSeriesRecommendations getTvSeriesRecommendations;
  final GetWatchListStatusTvSeries getWatchListStatusTvSeries;
  final SaveWatchlistTvSeries saveWatchlistTvSeries;
  final RemoveWatchlistTvSeries removeWatchlistTvSeries;

  late TvSeriesDetail _tvSeriesDetail;
  late List<TvSeries> _recommendations;
  late bool _isAddedToWatchlist;

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
    final recommendationResult = await getTvSeriesRecommendations.execute(event.id);

    detailResult.fold(
      (failure) => emit(TvSeriesDetailError(failure.message)),
      (tvSeries) {
        _tvSeriesDetail = tvSeries;
        recommendationResult.fold(
          (failure) {
            emit(TvSeriesDetailError(failure.message));
          },
          (recommendations) {
            _recommendations = recommendations;
          },
        );

        _loadWatchlistStatus(event.id, emit);
      },
    );
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
    if (currentState is TvSeriesDetailLoaded || currentState is TvSeriesDetailWatchlistUpdated) {
      emit(TvSeriesDetailWatchlistUpdated(
        tvSeries: _tvSeriesDetail,
        recommendations: _recommendations,
        isAddedToWatchlist: _isAddedToWatchlist,
        watchlistMessage: watchlistMessage,
      ));
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
    if (currentState is TvSeriesDetailLoaded || currentState is TvSeriesDetailWatchlistUpdated) {
      emit(TvSeriesDetailWatchlistUpdated(
        tvSeries: _tvSeriesDetail,
        recommendations: _recommendations,
        isAddedToWatchlist: _isAddedToWatchlist,
        watchlistMessage: watchlistMessage,
      ));
    }
  }

  Future<void> _onLoadTvSeriesWatchlistStatus(
    LoadTvSeriesWatchlistStatusEvent event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    _loadWatchlistStatus(event.id, emit);
  }

  Future<void> _loadWatchlistStatus(
    int id,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    final result = await getWatchListStatusTvSeries.execute(id);
    _isAddedToWatchlist = result;

    if (state is! TvSeriesDetailInitial) {
      emit(TvSeriesDetailLoaded(
        tvSeries: _tvSeriesDetail,
        recommendations: _recommendations,
        isAddedToWatchlist: _isAddedToWatchlist,
      ));
    }
  }
}
