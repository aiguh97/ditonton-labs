part of 'now_playing_tv_series_bloc.dart';

abstract class NowPlayingTvSeriesState extends Equatable {
  const NowPlayingTvSeriesState();

  @override
  List<Object> get props => [];
}

class NowPlayingTvSeriesInitial extends NowPlayingTvSeriesState {
  const NowPlayingTvSeriesInitial();
}

class NowPlayingTvSeriesLoading extends NowPlayingTvSeriesState {
  const NowPlayingTvSeriesLoading();
}

class NowPlayingTvSeriesLoaded extends NowPlayingTvSeriesState {
  final List<TvSeries> tvSeries;

  const NowPlayingTvSeriesLoaded(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class NowPlayingTvSeriesError extends NowPlayingTvSeriesState {
  final String message;

  const NowPlayingTvSeriesError(this.message);

  @override
  List<Object> get props => [message];
}
