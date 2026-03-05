part of 'tv_series_search_bloc.dart';

abstract class TvSeriesSearchState extends Equatable {
  const TvSeriesSearchState();

  @override
  List<Object> get props => [];
}

class TvSeriesSearchInitial extends TvSeriesSearchState {
  const TvSeriesSearchInitial();
}

class TvSeriesSearchLoading extends TvSeriesSearchState {
  const TvSeriesSearchLoading();
}

class TvSeriesSearchLoaded extends TvSeriesSearchState {
  final List<TvSeries> tvSeries;

  const TvSeriesSearchLoaded(this.tvSeries);

  @override
  List<Object> get props => [tvSeries];
}

class TvSeriesSearchError extends TvSeriesSearchState {
  final String message;

  const TvSeriesSearchError(this.message);

  @override
  List<Object> get props => [message];
}
