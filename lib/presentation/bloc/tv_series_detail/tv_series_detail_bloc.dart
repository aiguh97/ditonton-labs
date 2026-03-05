import 'package:ditonton/domain/usecases/tv_series/get_tv_series_detail.dart';
import 'package:ditonton/domain/usecases/tv_series/get_tv_series_recommendations.dart';
import 'package:ditonton/domain/usecases/tv_series/get_watchlist_status_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/remove_watchlist_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/save_watchlist_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series_detail/tv_series_detail_event.dart';
import 'package:ditonton/presentation/bloc/tv_series_detail/tv_series_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TvSeriesDetailBloc extends Bloc<TvSeriesDetailEvent, TvSeriesDetailState> {
  final GetTvSeriesDetail getTvSeriesDetail;
  final GetTvSeriesRecommendations getTvSeriesRecommendations;
  final GetWatchListStatusTvSeries getWatchListStatusTvSeries;
  final SaveWatchlistTvSeries saveWatchlistTvSeries;
  final RemoveWatchlistTvSeries removeWatchlistTvSeries;

  TvSeriesDetailBloc(
    this.getTvSeriesDetail,
    this.getTvSeriesRecommendations,
    this.getWatchListStatusTvSeries,
    this.saveWatchlistTvSeries,
    this.removeWatchlistTvSeries,
  ) : super(TvSeriesDetailEmpty()) {
    on<FetchTvSeriesDetailEvent>(_onFetchDetail);
    on<AddWatchlistTvSeriesEvent>(_onAddWatchlist);
    on<RemoveWatchlistTvSeriesEvent>(_onRemoveWatchlist);
    on<LoadWatchlistStatusTvSeriesEvent>(_onLoadStatus);
  }

  Future<void> _onFetchDetail(
    FetchTvSeriesDetailEvent event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    emit(TvSeriesDetailLoading());

    final detailResult = await getTvSeriesDetail.execute(event.id);

    final recommendationResult = await getTvSeriesRecommendations.execute(
      event.id,
    );

    detailResult.fold((failure) => emit(TvSeriesDetailError(failure.message)), (
      tvSeries,
    ) async {
      recommendationResult.fold(
        (failure) => emit(TvSeriesDetailError(failure.message)),
        (recommendations) => emit(TvSeriesDetailLoaded(tvSeries, recommendations)),
      );
    });
  }

  Future<void> _onAddWatchlist(
    AddWatchlistTvSeriesEvent event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    final result = await saveWatchlistTvSeries.execute(event.tvSeries);

    result.fold(
      (failure) => emit(TvSeriesDetailError(failure.message)),
      (successMessage) => emit(WatchlistStatusTvSeriesLoaded(true)),
    );
  }

  Future<void> _onRemoveWatchlist(
    RemoveWatchlistTvSeriesEvent event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    final result = await removeWatchlistTvSeries.execute(event.tvSeries);

    result.fold(
      (failure) => emit(TvSeriesDetailError(failure.message)),
      (successMessage) => emit(WatchlistStatusTvSeriesLoaded(false)),
    );
  }

  Future<void> _onLoadStatus(
    LoadWatchlistStatusTvSeriesEvent event,
    Emitter<TvSeriesDetailState> emit,
  ) async {
    final isAdded = await getWatchListStatusTvSeries.execute(event.id);
    emit(WatchlistStatusTvSeriesLoaded(isAdded));
  }
}