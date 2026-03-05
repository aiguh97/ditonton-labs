import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/domain/usecases/movies/get_movie_detail.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieDetailBloc extends Bloc<MovieEvent, MovieState> {
  final GetMovieDetail getMovieDetail;

  MovieDetailBloc(this.getMovieDetail) : super(MovieEmpty()) {
    on<FetchMovieDetail>((event, emit) async {
      emit(MovieLoading());

      final result = await getMovieDetail.execute(event.id);

      result.fold(
        (failure) => emit(MovieError(failure.message)),
        (data) => emit(MovieDetailHasData(data)),
      );
    });
  }
}
