import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';
import 'package:ditonton/domain/repositories/movie_repository.dart';
import 'package:ditonton/domain/usecases/movies/get_movie_detail.dart';
import 'package:ditonton/domain/usecases/movies/get_movie_recommendations.dart';
import 'package:ditonton/domain/usecases/movies/get_watchlist_status.dart';
import 'package:ditonton/domain/usecases/movies/save_watchlist.dart';
import 'package:ditonton/domain/usecases/movies/remove_watchlist.dart';
import 'package:ditonton/presentation/bloc/movies/movie_detail/movie_detail_bloc.dart';
import 'package:ditonton/presentation/pages/movies/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../dummy_data/movies/dummy_objects.dart';

class _FakeMovieRepository implements MovieRepository {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class StubGetMovieDetail extends GetMovieDetail {
  final Future<Either<Failure, MovieDetail>> Function(int) _executor;
  StubGetMovieDetail(this._executor) : super(_FakeMovieRepository());
  @override
  Future<Either<Failure, MovieDetail>> execute(int id) => _executor(id);
}

class StubGetMovieRecommendations extends GetMovieRecommendations {
  final Future<Either<Failure, List<Movie>>> Function(int) _executor;
  StubGetMovieRecommendations(this._executor) : super(_FakeMovieRepository());
  @override
  Future<Either<Failure, List<Movie>>> execute(id) => _executor(id);
}

class StubGetWatchlistStatus extends GetWatchListStatus {
  final Future<bool> Function(int) _executor;
  StubGetWatchlistStatus(this._executor) : super(_FakeMovieRepository());
  @override
  Future<bool> execute(int id) => _executor(id);
}

class StubSaveWatchlist extends SaveWatchlist {
  final Future<Either<Failure, String>> Function(MovieDetail) _executor;
  StubSaveWatchlist(this._executor) : super(_FakeMovieRepository());
  @override
  Future<Either<Failure, String>> execute(MovieDetail movie) => _executor(movie);
}

class StubRemoveWatchlist extends RemoveWatchlist {
  final Future<Either<Failure, String>> Function(MovieDetail) _executor;
  StubRemoveWatchlist(this._executor) : super(_FakeMovieRepository());
  @override
  Future<Either<Failure, String>> execute(MovieDetail movie) => _executor(movie);
}

Widget _makeTestableWidget(MovieDetailBloc bloc) {
  return MaterialApp(
    home: BlocProvider<MovieDetailBloc>.value(
      value: bloc,
      child: MovieDetailPage(id: 1),
    ),
  );
}

void main() {
  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    final detailStub = StubGetMovieDetail((id) async => Right(testMovieDetail));
    final recomStub = StubGetMovieRecommendations((id) async => const Right(<Movie>[]));
    final statusStub = StubGetWatchlistStatus((id) async => false);
    final saveStub = StubSaveWatchlist((movie) async => const Right('Added to Watchlist'));
    final removeStub = StubRemoveWatchlist((movie) async => const Right('Removed from Watchlist'));

    final bloc = MovieDetailBloc(
      getMovieDetail: detailStub,
      getMovieRecommendations: recomStub,
      getWatchListStatus: statusStub,
      saveWatchlist: saveStub,
      removeWatchlist: removeStub,
    );

    await tester.pumpWidget(_makeTestableWidget(bloc));
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should dispay check icon when movie is added to wathclist',
      (WidgetTester tester) async {
    final detailStub = StubGetMovieDetail((id) async => Right(testMovieDetail));
    final recomStub = StubGetMovieRecommendations((id) async => const Right(<Movie>[]));
    final statusStub = StubGetWatchlistStatus((id) async => true);
    final saveStub = StubSaveWatchlist((movie) async => const Right('Added to Watchlist'));
    final removeStub = StubRemoveWatchlist((movie) async => const Right('Removed from Watchlist'));

    final bloc = MovieDetailBloc(
      getMovieDetail: detailStub,
      getMovieRecommendations: recomStub,
      getWatchListStatus: statusStub,
      saveWatchlist: saveStub,
      removeWatchlist: removeStub,
    );

    await tester.pumpWidget(_makeTestableWidget(bloc));
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.byIcon(Icons.check), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display Snackbar when added to watchlist',
      (WidgetTester tester) async {
    final detailStub = StubGetMovieDetail((id) async => Right(testMovieDetail));
    final recomStub = StubGetMovieRecommendations((id) async => const Right(<Movie>[]));
    final statusStub = StubGetWatchlistStatus((id) async => false);
    final saveStub = StubSaveWatchlist((movie) async => const Right('Added to Watchlist'));
    final removeStub = StubRemoveWatchlist((movie) async => const Right('Removed from Watchlist'));

    final bloc = MovieDetailBloc(
      getMovieDetail: detailStub,
      getMovieRecommendations: recomStub,
      getWatchListStatus: statusStub,
      saveWatchlist: saveStub,
      removeWatchlist: removeStub,
    );

    await tester.pumpWidget(_makeTestableWidget(bloc));
    await tester.pump(const Duration(milliseconds: 200));

    final watchlistButton = find.byType(ElevatedButton);
    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.text('Added to Watchlist'), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display AlertDialog when add to watchlist failed',
      (WidgetTester tester) async {
    final detailStub = StubGetMovieDetail((id) async => Right(testMovieDetail));
    final recomStub = StubGetMovieRecommendations((id) async => const Right(<Movie>[]));
    final statusStub = StubGetWatchlistStatus((id) async => false);
    final saveStub = StubSaveWatchlist((movie) async => Left(ServerFailure('Failed')));
    final removeStub = StubRemoveWatchlist((movie) async => const Right('Removed from Watchlist'));

    final bloc = MovieDetailBloc(
      getMovieDetail: detailStub,
      getMovieRecommendations: recomStub,
      getWatchListStatus: statusStub,
      saveWatchlist: saveStub,
      removeWatchlist: removeStub,
    );

    await tester.pumpWidget(_makeTestableWidget(bloc));
    await tester.pump(const Duration(milliseconds: 200));

    final watchlistButton = find.byType(ElevatedButton);
    expect(find.byIcon(Icons.add), findsOneWidget);

    await tester.tap(watchlistButton);
    await tester.pump(const Duration(milliseconds: 200));
    await tester.pump(const Duration(milliseconds: 200));

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
