import 'package:ditonton/domain/usecases/tv_series/get_now_playing_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_popular_tv_series.dart';
import 'package:ditonton/domain/usecases/tv_series/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv/tv_event.dart';
import 'package:ditonton/presentation/bloc/tv/tv_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NowPlayingTvSeriesBloc extends Bloc<TvEvent, TvState> {
  final GetNowPlayingTvSeries _getNowPlayingTvSeries;

  NowPlayingTvSeriesBloc(this._getNowPlayingTvSeries) : super(TvEmpty()) {
    on<FetchNowPlayingTvSeries>((event, emit) async {
      emit(TvLoading());
      final result = await _getNowPlayingTvSeries.execute();
      result.fold(
        (failure) => emit(TvError(failure.message)),
        (data) => emit(TvHasData(data)),
      );
    });
  }
}

class PopularTvSeriesBloc extends Bloc<TvEvent, TvState> {
  final GetPopularTvSeries _getPopularTvSeries;

  PopularTvSeriesBloc(this._getPopularTvSeries) : super(TvEmpty()) {
    on<FetchPopularTvSeries>((event, emit) async {
      emit(TvLoading());
      final result = await _getPopularTvSeries.execute();
      result.fold(
        (failure) => emit(TvError(failure.message)),
        (data) => emit(TvHasData(data)),
      );
    });
  }
}

class TopRatedTvSeriesBloc extends Bloc<TvEvent, TvState> {
  final GetTopRatedTvSeries _getTopRatedTvSeries;

  TopRatedTvSeriesBloc(this._getTopRatedTvSeries) : super(TvEmpty()) {
    on<FetchTopRatedTvSeries>((event, emit) async {
      emit(TvLoading());
      final result = await _getTopRatedTvSeries.execute();
      result.fold(
        (failure) => emit(TvError(failure.message)),
        (data) => emit(TvHasData(data)),
      );
    });
  }
}