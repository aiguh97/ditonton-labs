part of 'tv_series_list_bloc.dart';

abstract class TvSeriesListState extends Equatable {
  const TvSeriesListState();

  @override
  List<Object> get props => [];
}

class TvSeriesListInitial extends TvSeriesListState {
  const TvSeriesListInitial();
}

class NowPlayingTvSeriesLoading extends TvSeriesListState {
  const NowPlayingTvSeriesLoading();
}

class NowPlayingTvSeriesLoaded extends TvSeriesListState {
  final List<TvSeries> tvSeries;

  const NowPlayingTvSeriesLoaded(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class NowPlayingTvSeriesError extends TvSeriesListState {
  final String message;

  const NowPlayingTvSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class PopularTvSeriesLoading extends TvSeriesListState {
  const PopularTvSeriesLoading();
}

class PopularTvSeriesLoaded extends TvSeriesListState {
  final List<TvSeries> tvSeries;

  const PopularTvSeriesLoaded(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class PopularTvSeriesError extends TvSeriesListState {
  final String message;

  const PopularTvSeriesError(this.message);

  @override
  List<Object> get props => [message];
}

class TopRatedTvSeriesLoading extends TvSeriesListState {
  const TopRatedTvSeriesLoading();
}

class TopRatedTvSeriesLoaded extends TvSeriesListState {
  final List<TvSeries> tvSeries;

  const TopRatedTvSeriesLoaded(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class TopRatedTvSeriesError extends TvSeriesListState {
  final String message;

  const TopRatedTvSeriesError(this.message);

  @override
  List<Object> get props => [message];
}
