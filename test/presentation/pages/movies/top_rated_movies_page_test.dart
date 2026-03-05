import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/usecases/movies/get_top_rated_movies.dart';
import 'package:ditonton/presentation/bloc/movies/top_rated_movies/top_rated_movies_bloc.dart';
import 'package:ditonton/presentation/pages/movies/top_rated_movies_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StubGetTopRatedMovies extends GetTopRatedMovies {
  final Future<Either<Failure, List<Movie>>> Function() _executor;

  StubGetTopRatedMovies(this._executor) : super(_FakeMovieRepository());

  @override
  Future<Either<Failure, List<Movie>>> execute() => _executor();
}

class _FakeMovieRepository implements MovieRepository {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

Widget _makeTestableWidget(TopRatedMoviesBloc bloc) {
  return MaterialApp(
    home: BlocProvider<TopRatedMoviesBloc>.value(
      value: bloc,
      child: TopRatedMoviesPage(),
    ),
  );
}

void main() {
  testWidgets('Page should display progress bar when loading',
      (WidgetTester tester) async {
    final completer = Completer<Either<Failure, List<Movie>>>();
    final stub = StubGetTopRatedMovies(() => completer.future);
    final bloc = TopRatedMoviesBloc(getTopRatedMovies: stub);

    await tester.pumpWidget(_makeTestableWidget(bloc));
    await tester.pump();

    expect(find.byType(Center), findsWidgets);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display when data is loaded',
      (WidgetTester tester) async {
    final stub = StubGetTopRatedMovies(() async => Right(<Movie>[]));
    final bloc = TopRatedMoviesBloc(getTopRatedMovies: stub);

    await tester.pumpWidget(_makeTestableWidget(bloc));
    await tester.pumpAndSettle();

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    final stub = StubGetTopRatedMovies(() async => Left(ServerFailure('Error message')));
    final bloc = TopRatedMoviesBloc(getTopRatedMovies: stub);

    await tester.pumpWidget(_makeTestableWidget(bloc));
    await tester.pumpAndSettle();

    final textFinder = find.byKey(const Key('error_message'));
    expect(textFinder, findsOneWidget);
  });
}
