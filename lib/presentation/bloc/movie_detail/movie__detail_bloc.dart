import 'package:ditonton/domain/usecases/movies/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/movies/get_movie_recommendations.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_event.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MovieDetailBloc extends Bloc<MovieDetailEvent, MovieDetailState> {
  final GetMovieDetail _getMovieDetail;
  final GetMovieRecommendations _getMovieRecommendations;

  MovieDetailBloc(this._getMovieDetail, this._getMovieRecommendations)
    : super(MovieDetailEmpty()) {
    on<FetchMovieDetail>((event, emit) async {
      emit(MovieDetailLoading());

      final detailResult = await _getMovieDetail.execute(event.id);
      final recommendationResult = await _getMovieRecommendations.execute(
        event.id,
      );

      detailResult.fold((failure) => emit(MovieDetailError(failure.message)), (
        movieDetail,
      ) {
        recommendationResult.fold(
          (failure) => emit(MovieDetailError(failure.message)),
          (recommendations) {
            emit(
              MovieDetailHasData(
                movieDetail: movieDetail,
                recommendations: recommendations,
              ),
            );
          },
        );
      });
    });
  }
}
