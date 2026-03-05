part of 'tv_series_detail_bloc.dart';

abstract class TvSeriesDetailEvent extends Equatable {
  const TvSeriesDetailEvent();

  @override
  List<Object> get props => [];
}

class FetchTvSeriesDetailEvent extends TvSeriesDetailEvent {
  final int id;

  const FetchTvSeriesDetailEvent(this.id);

  @override
  List<Object> get props => [id];
}

class AddTvSeriesToWatchlistEvent extends TvSeriesDetailEvent {
  final TvSeriesDetail tvSeries;

  const AddTvSeriesToWatchlistEvent(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class RemoveTvSeriesFromWatchlistEvent extends TvSeriesDetailEvent {
  final TvSeriesDetail tvSeries;

  const RemoveTvSeriesFromWatchlistEvent(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class LoadTvSeriesWatchlistStatusEvent extends TvSeriesDetailEvent {
  final int id;

  const LoadTvSeriesWatchlistStatusEvent(this.id);

  @override
  List<Object> get props => [id];
}
