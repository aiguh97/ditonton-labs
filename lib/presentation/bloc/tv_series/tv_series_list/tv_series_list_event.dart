part of 'tv_series_list_bloc.dart';

abstract class TvSeriesListEvent extends Equatable {
  const TvSeriesListEvent();

  @override
  List<Object> get props => [];
}

class FetchNowPlayingTvSeriesEvent extends TvSeriesListEvent {
  const FetchNowPlayingTvSeriesEvent();
}

class FetchPopularTvSeriesEvent extends TvSeriesListEvent {
  const FetchPopularTvSeriesEvent();
}

class FetchTopRatedTvSeriesEvent extends TvSeriesListEvent {
  const FetchTopRatedTvSeriesEvent();
}
