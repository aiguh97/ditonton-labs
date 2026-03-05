import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_watchlist_tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'watchlist_tv_series_event.dart';
part 'watchlist_tv_series_state.dart';

class WatchlistTvSeriesBloc extends Bloc<WatchlistTvSeriesEvent, WatchlistTvSeriesState> {
  final GetWatchlistTvSeries getWatchlistTvSeries;

  WatchlistTvSeriesBloc({required this.getWatchlistTvSeries})
      : super(const WatchlistTvSeriesInitial()) {
    on<FetchWatchlistTvSeriesEvent>(_onFetchWatchlistTvSeries);
  }

  Future<void> _onFetchWatchlistTvSeries(
    FetchWatchlistTvSeriesEvent event,
    Emitter<WatchlistTvSeriesState> emit,
  ) async {
    emit(const WatchlistTvSeriesLoading());

    final result = await getWatchlistTvSeries.execute();
    result.fold(
      (failure) => emit(WatchlistTvSeriesError(failure.message)),
      (tvSeries) => emit(WatchlistTvSeriesLoaded(tvSeries)),
    );
  }
}
