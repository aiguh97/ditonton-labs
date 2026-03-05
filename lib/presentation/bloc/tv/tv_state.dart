import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';
import 'package:equatable/equatable.dart';

abstract class TvState extends Equatable {
  const TvState();

  @override
  List<Object> get props => [];
}

class TvEmpty extends TvState {}

class TvLoading extends TvState {}

class TvHasData extends TvState {
  final List<TvSeries> result;

  const TvHasData(this.result);

  @override
  List<Object> get props => [result];
}

class TvDetailHasData extends TvState {
  final TvSeriesDetail result;

  const TvDetailHasData(this.result);

  @override
  List<Object> get props => [result];
}

class TvError extends TvState {
  final String message;

  const TvError(this.message);

  @override
  List<Object> get props => [message];
}

// Aliases so pages can use TvSeriesState / TvSeriesLoading / ... naming.
typedef TvSeriesState = TvState;
typedef TvSeriesEmpty = TvEmpty;
typedef TvSeriesLoading = TvLoading;
typedef TvSeriesHasData = TvHasData;
typedef TvSeriesError = TvError;