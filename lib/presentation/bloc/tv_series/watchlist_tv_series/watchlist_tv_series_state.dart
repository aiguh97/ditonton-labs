part of 'watchlist_tv_series_bloc.dart';

abstract class WatchlistTvSeriesState extends Equatable {
  const WatchlistTvSeriesState();

  @override
  List<Object> get props => [];
}

class WatchlistTvSeriesInitial extends WatchlistTvSeriesState {
  const WatchlistTvSeriesInitial();
}

class WatchlistTvSeriesLoading extends WatchlistTvSeriesState {
  const WatchlistTvSeriesLoading();
}

class WatchlistTvSeriesLoaded extends WatchlistTvSeriesState {
  final List<TvSeries> tvSeries;

  const WatchlistTvSeriesLoaded(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class WatchlistTvSeriesError extends WatchlistTvSeriesState {
  final String message;

  const WatchlistTvSeriesError(this.message);

  @override
  List<Object> get props => [message];
}
