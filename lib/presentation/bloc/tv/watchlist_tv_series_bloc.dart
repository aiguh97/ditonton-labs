import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/domain/usecases/tv_series/get_watchlist_tv_series.dart';
import 'tv_event.dart';
import 'tv_state.dart';

class WatchlistTvSeriesBloc extends Bloc<TvEvent, TvState> {
  final GetWatchlistTvSeries getWatchlistTvSeries;

  WatchlistTvSeriesBloc(this.getWatchlistTvSeries) : super(TvEmpty()) {
    on<FetchWatchlistTvSeriesEvent>((event, emit) async {
      emit(TvLoading());

      final result = await getWatchlistTvSeries.execute();

      result.fold(
        (failure) => emit(TvError(failure.message)),
        (data) => emit(TvHasData(data)),
      );
    });
  }
}
