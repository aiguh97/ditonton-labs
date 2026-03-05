import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_now_playing_tv_series.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'now_playing_tv_series_event.dart';
part 'now_playing_tv_series_state.dart';

class NowPlayingTvSeriesBloc
    extends Bloc<NowPlayingTvSeriesEvent, NowPlayingTvSeriesState> {
  final GetNowPlayingTvSeries getNowPlayingTvSeries;

  NowPlayingTvSeriesBloc({required this.getNowPlayingTvSeries})
    : super(const NowPlayingTvSeriesInitial()) {
    on<FetchNowPlayingTvSeriesEvent>(_onFetchNowPlayingTvSeries);
  }

  Future<void> _onFetchNowPlayingTvSeries(
    FetchNowPlayingTvSeriesEvent event,
    Emitter<NowPlayingTvSeriesState> emit,
  ) async {
    emit(const NowPlayingTvSeriesLoading());

    final result = await getNowPlayingTvSeries.execute();
    result.fold(
      (failure) => emit(NowPlayingTvSeriesError(failure.message)),
      (tvSeries) => emit(NowPlayingTvSeriesLoaded(tvSeries)),
    );
  }
}
