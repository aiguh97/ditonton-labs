import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series_detail/tv_series_detail_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series_detail/tv_series_detail_state.dart';
import 'package:ditonton/presentation/pages/tv_series/tv_series_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/tv_series/dummy_objects.dart';

class MockTvSeriesDetailBloc
    extends MockBloc<dynamic, TvSeriesDetailState>
    implements TvSeriesDetailBloc {}

void main() {
  late MockTvSeriesDetailBloc mockBloc;

  setUp(() {
    mockBloc = MockTvSeriesDetailBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TvSeriesDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when tv series not added to watchlist',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(
      TvSeriesDetailLoaded(tTvSeriesDetail, const <TvSeries>[]),
    );

    await tester.pumpWidget(makeTestableWidget(TvSeriesDetailPage(id: 1)));
    await tester.pump();

    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when tv series added to watchlist',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(
      TvSeriesDetailLoaded(tTvSeriesDetail, const <TvSeries>[]),
    );
    whenListen(
      mockBloc,
      Stream.fromIterable([WatchlistStatusTvSeriesLoaded(true)]),
    );

    await tester.pumpWidget(makeTestableWidget(TvSeriesDetailPage(id: 1)));
    await tester.pump();

    expect(find.byIcon(Icons.check), findsOneWidget);
  });
}
