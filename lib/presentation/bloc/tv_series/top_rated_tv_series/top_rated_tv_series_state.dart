part of 'top_rated_tv_series_bloc.dart';

abstract class TopRatedTvSeriesState extends Equatable {
  const TopRatedTvSeriesState();

  @override
  List<Object> get props => [];
}

class TopRatedTvSeriesInitial extends TopRatedTvSeriesState {
  const TopRatedTvSeriesInitial();
}

class TopRatedTvSeriesLoading extends TopRatedTvSeriesState {
  const TopRatedTvSeriesLoading();
}

class TopRatedTvSeriesLoaded extends TopRatedTvSeriesState {
  final List<TvSeries> tvSeries;

  const TopRatedTvSeriesLoaded(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class TopRatedTvSeriesError extends TopRatedTvSeriesState {
  final String message;

  const TopRatedTvSeriesError(this.message);

  @override
  List<Object> get props => [message];
}
