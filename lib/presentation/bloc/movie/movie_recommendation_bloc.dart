import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/domain/usecases/movies/get_movie_recommendations.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieRecommendationBloc extends Bloc<MovieEvent, MovieState> {
  final GetMovieRecommendations getRecommendations;

  MovieRecommendationBloc(this.getRecommendations) : super(MovieEmpty()) {
    on<FetchMovieRecommendations>((event, emit) async {
      emit(MovieLoading());

      final result = await getRecommendations.execute(event.id);

      result.fold(
        (failure) => emit(MovieError(failure.message)),
        (data) => emit(MovieHasData(data)),
      );
    });
  }
}
