import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_top_rated_tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'top_rated_tv_series_event.dart';
part 'top_rated_tv_series_state.dart';

class TopRatedTvSeriesBloc extends Bloc<TopRatedTvSeriesEvent, TopRatedTvSeriesState> {
  final GetTopRatedTvSeries getTopRatedTvSeries;

  TopRatedTvSeriesBloc({required this.getTopRatedTvSeries})
      : super(const TopRatedTvSeriesInitial()) {
    on<FetchTopRatedTvSeriesEvent>(_onFetchTopRatedTvSeries);
  }

  Future<void> _onFetchTopRatedTvSeries(
    FetchTopRatedTvSeriesEvent event,
    Emitter<TopRatedTvSeriesState> emit,
  ) async {
    emit(const TopRatedTvSeriesLoading());

    final result = await getTopRatedTvSeries.execute();
    result.fold(
      (failure) => emit(TopRatedTvSeriesError(failure.message)),
      (tvSeries) => emit(TopRatedTvSeriesLoaded(tvSeries)),
    );
  }
}
