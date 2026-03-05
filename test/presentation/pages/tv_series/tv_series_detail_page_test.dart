import 'dart:async';

import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/bloc/tv_series/tv_series_detail/tv_series_detail_bloc.dart';
import 'package:ditonton/presentation/pages/tv_series/tv_series_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import '../../../dummy_data/tv_series/dummy_objects.dart';
import 'tv_series_detail_page_test.mocks.dart';

@GenerateMocks([TvSeriesDetailBloc])
void main() {
  late MockTvSeriesDetailBloc mockBloc;

  setUp(() {
    mockBloc = MockTvSeriesDetailBloc();

    when(mockBloc.stream).thenAnswer((_) => const Stream.empty());
    when(mockBloc.close()).thenAnswer((_) async {});
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
      when(mockBloc.state).thenReturn(
        TvSeriesDetailLoaded(
          tvSeries: tTvSeriesDetail,
          recommendations: <TvSeries>[],
          isAddedToWatchlist: false,
        ),
      );

      await tester.pumpWidget(makeTestableWidget(TvSeriesDetailPage(id: 1)));

      await tester.pump();

      expect(find.byIcon(Icons.add), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display check icon when tv series is added to watchlist',
    (WidgetTester tester) async {
      when(mockBloc.state).thenReturn(
        TvSeriesDetailLoaded(
          tvSeries: tTvSeriesDetail,
          recommendations: <TvSeries>[],
          isAddedToWatchlist: true,
        ),
      );

      await tester.pumpWidget(makeTestableWidget(TvSeriesDetailPage(id: 1)));

      await tester.pump();

      expect(find.byIcon(Icons.check), findsOneWidget);
    },
  );

  testWidgets(
    'Watchlist button should display Snackbar when added to watchlist',
    (WidgetTester tester) async {
      final controller = StreamController<TvSeriesDetailState>.broadcast();

      when(mockBloc.stream).thenAnswer((_) => controller.stream);

      when(mockBloc.state).thenReturn(
        TvSeriesDetailLoaded(
          tvSeries: tTvSeriesDetail,
          recommendations: [],
          isAddedToWatchlist: false,
        ),
      );

      await tester.pumpWidget(makeTestableWidget(TvSeriesDetailPage(id: 1)));

      controller.add(
        TvSeriesDetailWatchlistUpdated(
          tvSeries: tTvSeriesDetail,
          recommendations: [],
          isAddedToWatchlist: true,
          watchlistMessage: TvSeriesDetailBloc.watchlistAddSuccessMessage,
        ),
      );

      await tester.pump();

      expect(find.byType(SnackBar), findsOneWidget);
      expect(
        find.text(TvSeriesDetailBloc.watchlistAddSuccessMessage),
        findsOneWidget,
      );
    },
  );

  testWidgets(
    'Watchlist button should display AlertDialog when add to watchlist failed',
    (WidgetTester tester) async {
      final controller = StreamController<TvSeriesDetailState>.broadcast();

      when(mockBloc.stream).thenAnswer((_) => controller.stream);

      when(mockBloc.state).thenReturn(
        TvSeriesDetailLoaded(
          tvSeries: tTvSeriesDetail,
          recommendations: [],
          isAddedToWatchlist: false,
        ),
      );

      await tester.pumpWidget(makeTestableWidget(TvSeriesDetailPage(id: 1)));

      controller.add(
        TvSeriesDetailWatchlistUpdated(
          tvSeries: tTvSeriesDetail,
          recommendations: [],
          isAddedToWatchlist: false,
          watchlistMessage: 'Failed',
        ),
      );

      await tester.pump();

      expect(find.byType(AlertDialog), findsOneWidget);
      expect(find.text('Failed'), findsOneWidget);
    },
  );
}
