import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/domain/usecases/tv_series/search_tv_series.dart';
import 'tv_event.dart';
import 'tv_state.dart';

class TvSeriesSearchBloc extends Bloc<TvEvent, TvState> {
  final SearchTvSeries searchTvSeries;

  TvSeriesSearchBloc(this.searchTvSeries) : super(TvEmpty()) {
    on<SearchTvSeriesEvent>((event, emit) async {
      emit(TvLoading());

      final result = await searchTvSeries.execute(event.query);

      result.fold(
        (failure) => emit(TvError(failure.message)),
        (data) => emit(TvHasData(data)),
      );
    });
  }
}
