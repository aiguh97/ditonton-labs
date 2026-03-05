part of 'popular_tv_series_bloc.dart';

abstract class PopularTvSeriesEvent extends Equatable {
  const PopularTvSeriesEvent();

  @override
  List<Object> get props => [];
}

class FetchPopularTvSeriesEvent extends PopularTvSeriesEvent {
  const FetchPopularTvSeriesEvent();
}
