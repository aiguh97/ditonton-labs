import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_now_playing_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_top_rated_tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'tv_series_list_event.dart';
part 'tv_series_list_state.dart';

class TvSeriesListBloc extends Bloc<TvSeriesListEvent, TvSeriesListState> {
  final GetNowPlayingTvSeries getNowPlayingTvSeries;
  final GetPopularTvSeries getPopularTvSeries;
  final GetTopRatedTvSeries getTopRatedTvSeries;

  TvSeriesListBloc({
    required this.getNowPlayingTvSeries,
    required this.getPopularTvSeries,
    required this.getTopRatedTvSeries,
  }) : super(const TvSeriesListInitial()) {
    on<FetchNowPlayingTvSeriesEvent>(_onFetchNowPlayingTvSeries);
    on<FetchPopularTvSeriesEvent>(_onFetchPopularTvSeries);
    on<FetchTopRatedTvSeriesEvent>(_onFetchTopRatedTvSeries);
  }

  Future<void> _onFetchNowPlayingTvSeries(
    FetchNowPlayingTvSeriesEvent event,
    Emitter<TvSeriesListState> emit,
  ) async {
    emit(const NowPlayingTvSeriesLoading());

    final result = await getNowPlayingTvSeries.execute();
    result.fold(
      (failure) => emit(NowPlayingTvSeriesError(failure.message)),
      (tvSeries) => emit(NowPlayingTvSeriesLoaded(tvSeries)),
    );
  }

  Future<void> _onFetchPopularTvSeries(
    FetchPopularTvSeriesEvent event,
    Emitter<TvSeriesListState> emit,
  ) async {
    emit(const PopularTvSeriesLoading());

    final result = await getPopularTvSeries.execute();
    result.fold(
      (failure) => emit(PopularTvSeriesError(failure.message)),
      (tvSeries) => emit(PopularTvSeriesLoaded(tvSeries)),
    );
  }

  Future<void> _onFetchTopRatedTvSeries(
    FetchTopRatedTvSeriesEvent event,
    Emitter<TvSeriesListState> emit,
  ) async {
    emit(const TopRatedTvSeriesLoading());

    final result = await getTopRatedTvSeries.execute();
    result.fold(
      (failure) => emit(TopRatedTvSeriesError(failure.message)),
      (tvSeries) => emit(TopRatedTvSeriesLoaded(tvSeries)),
    );
  }
}
