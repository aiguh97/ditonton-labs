import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';

abstract class TvSeriesDetailState {}

class TvSeriesDetailEmpty extends TvSeriesDetailState {}

class TvSeriesDetailLoading extends TvSeriesDetailState {}

class TvSeriesDetailLoaded extends TvSeriesDetailState {
  final TvSeriesDetail tvSeries;
  final List<TvSeries> recommendations;

  TvSeriesDetailLoaded(this.tvSeries, this.recommendations);
}

class WatchlistStatusTvSeriesLoaded extends TvSeriesDetailState {
  final bool isAdded;

  WatchlistStatusTvSeriesLoaded(this.isAdded);
}

class TvSeriesDetailError extends TvSeriesDetailState {
  final String message;

  TvSeriesDetailError(this.message);
}