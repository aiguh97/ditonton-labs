import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/usecases/movies/search_movies.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

part 'movie_search_event.dart';
part 'movie_search_state.dart';

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final SearchMovies searchMovies;

  MovieSearchBloc({required this.searchMovies}) : super(const MovieSearchInitial()) {
    on<SearchMoviesEvent>(_onSearchMovies);
  }

  Future<void> _onSearchMovies(
    SearchMoviesEvent event,
    Emitter<MovieSearchState> emit,
  ) async {
    emit(const MovieSearchLoading());

    final result = await searchMovies.execute(event.query);
    result.fold(
      (failure) => emit(MovieSearchError(failure.message)),
      (movies) => emit(MovieSearchLoaded(movies)),
    );
  }
}
