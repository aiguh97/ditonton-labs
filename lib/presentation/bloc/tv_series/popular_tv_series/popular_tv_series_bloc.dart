import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_popular_tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'popular_tv_series_event.dart';
part 'popular_tv_series_state.dart';

class PopularTvSeriesBloc
    extends Bloc<PopularTvSeriesEvent, PopularTvSeriesState> {
  final GetPopularTvSeries getPopularTvSeries;

  PopularTvSeriesBloc({required this.getPopularTvSeries})
    : super(const PopularTvSeriesInitial()) {
    on<FetchPopularTvSeriesEvent>(_onFetchPopularTvSeries);
  }

  Future<void> _onFetchPopularTvSeries(
    FetchPopularTvSeriesEvent event,
    Emitter<PopularTvSeriesState> emit,
  ) async {
    emit(const PopularTvSeriesLoading());

    final result = await getPopularTvSeries.execute();
    result.fold(
      (failure) => emit(PopularTvSeriesError(failure.message)),
      (tvSeries) => emit(PopularTvSeriesLoaded(tvSeries)),
    );
  }
}
