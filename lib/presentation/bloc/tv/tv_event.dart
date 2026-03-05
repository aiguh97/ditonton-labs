import 'package:equatable/equatable.dart';

abstract class TvEvent extends Equatable {
  const TvEvent();

  @override
  List<Object> get props => [];
}

class FetchNowPlayingTvSeries extends TvEvent {}

class FetchPopularTvSeries extends TvEvent {}

class FetchTopRatedTvSeries extends TvEvent {}

class FetchTvSeriesDetail extends TvEvent {
  final int id;

  const FetchTvSeriesDetail(this.id);

  @override
  List<Object> get props => [id];
}

class FetchTvSeriesRecommendations extends TvEvent {
  final int id;

  const FetchTvSeriesRecommendations(this.id);

  @override
  List<Object> get props => [id];
}
// ================= WATCHLIST =================

class FetchWatchlistTvSeriesEvent extends TvEvent {}

class FetchPopularTvSeriesEvent extends TvEvent {}

class SearchTvSeriesEvent extends TvEvent {
  final String query;

  const SearchTvSeriesEvent(this.query);

  @override
  List<Object> get props => [query];
}