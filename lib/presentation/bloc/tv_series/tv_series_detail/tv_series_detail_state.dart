part of 'tv_series_detail_bloc.dart';

abstract class TvSeriesDetailState extends Equatable {
  const TvSeriesDetailState();

  @override
  List<Object> get props => [];
}

class TvSeriesDetailInitial extends TvSeriesDetailState {
  const TvSeriesDetailInitial();
}

class TvSeriesDetailLoading extends TvSeriesDetailState {
  const TvSeriesDetailLoading();
}

class TvSeriesDetailLoaded extends TvSeriesDetailState {
  final TvSeriesDetail tvSeries;
  final List<TvSeries> recommendations;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  const TvSeriesDetailLoaded({
    required this.tvSeries,
    required this.recommendations,
    required this.isAddedToWatchlist,
    this.watchlistMessage = '',
  });

  @override
  List<Object> get props =>
      [tvSeries, recommendations, isAddedToWatchlist, watchlistMessage];
}

class TvSeriesDetailError extends TvSeriesDetailState {
  final String message;

  const TvSeriesDetailError(this.message);

  @override
  List<Object> get props => [message];
}

class TvSeriesDetailWatchlistUpdated extends TvSeriesDetailState {
  final TvSeriesDetail tvSeries;
  final List<TvSeries> recommendations;
  final bool isAddedToWatchlist;
  final String watchlistMessage;

  const TvSeriesDetailWatchlistUpdated({
    required this.tvSeries,
    required this.recommendations,
    required this.isAddedToWatchlist,
    required this.watchlistMessage,
  });

  @override
  List<Object> get props =>
      [tvSeries, recommendations, isAddedToWatchlist, watchlistMessage];
}
