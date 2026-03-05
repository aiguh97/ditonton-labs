import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/domain/usecases/movies/search_movies.dart';
import 'movie_event.dart';
import 'movie_state.dart';

class MovieSearchBloc extends Bloc<MovieEvent, MovieState> {
  final SearchMovies searchMovies; // ini UseCase

  MovieSearchBloc(this.searchMovies) : super(MovieEmpty()) {
    on<SearchMoviesEvent>((event, emit) async {
      emit(MovieLoading());

      final result = await searchMovies.execute(event.query);

      result.fold(
        (failure) => emit(MovieError(failure.message)),
        (data) => emit(MovieHasData(data)),
      );
    });
  }
}
