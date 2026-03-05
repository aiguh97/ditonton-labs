import 'package:ditonton/domain/entities/tv_series_detail.dart';

abstract class TvSeriesDetailEvent {}

class FetchTvSeriesDetailEvent extends TvSeriesDetailEvent {
  final int id;

  FetchTvSeriesDetailEvent(this.id);
}

class FetchTvSeriesRecommendationsEvent extends TvSeriesDetailEvent {
  final int id;

  FetchTvSeriesRecommendationsEvent(this.id);
}

class AddWatchlistTvSeriesEvent extends TvSeriesDetailEvent {
  final TvSeriesDetail tvSeries;

  AddWatchlistTvSeriesEvent(this.tvSeries);
}

class RemoveWatchlistTvSeriesEvent extends TvSeriesDetailEvent {
  final TvSeriesDetail tvSeries;

  RemoveWatchlistTvSeriesEvent(this.tvSeries);
}

class LoadWatchlistStatusTvSeriesEvent extends TvSeriesDetailEvent {
  final int id;

  LoadWatchlistStatusTvSeriesEvent(this.id);
}