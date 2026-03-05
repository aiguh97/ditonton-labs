import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/repositories/tv_series_repository.dart';
import 'package:ditonton/domain/usecases/tv_series/get_top_rated_tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series/top_rated_tv_series/top_rated_tv_series_bloc.dart';
import 'package:ditonton/presentation/pages/tv_series/top_rated_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class _FakeTvRepo implements TvSeriesRepository {
  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class StubGetTopRatedTvSeries extends GetTopRatedTvSeries {
  final Future<Either<Failure, List<TvSeries>>> Function() _executor;
  StubGetTopRatedTvSeries(this._executor) : super(_FakeTvRepo());
  @override
  Future<Either<Failure, List<TvSeries>>> execute() => _executor();
}

Widget _makeTestableWidget(TopRatedTvSeriesBloc bloc) {
  return MaterialApp(
    home: BlocProvider<TopRatedTvSeriesBloc>.value(
      value: bloc,
      child: TopRatedTvSeriesPage(),
    ),
  );
}

void main() {
  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    final completer = Completer<Either<Failure, List<TvSeries>>>();
    final stub = StubGetTopRatedTvSeries(() => completer.future);
    final bloc = TopRatedTvSeriesBloc(getTopRatedTvSeries: stub);

    await tester.pumpWidget(_makeTestableWidget(bloc));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(Center), findsWidgets);
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    final stub = StubGetTopRatedTvSeries(() async => Right(<TvSeries>[]));
    final bloc = TopRatedTvSeriesBloc(getTopRatedTvSeries: stub);

    await tester.pumpWidget(_makeTestableWidget(bloc));
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    final stub = StubGetTopRatedTvSeries(() async => Left(ServerFailure('Error message')));
    final bloc = TopRatedTvSeriesBloc(getTopRatedTvSeries: stub);

    await tester.pumpWidget(_makeTestableWidget(bloc));
    await tester.pump(const Duration(milliseconds: 100));

    final textFinder = find.byKey(const Key('error_message'));
    expect(textFinder, findsOneWidget);
  });
}
