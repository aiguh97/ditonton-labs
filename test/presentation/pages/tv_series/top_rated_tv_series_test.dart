import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/presentation/bloc/tv/tv_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/tv_state.dart';
import 'package:ditonton/presentation/pages/tv_series/top_rated_tv_series_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class MockTopRatedTvSeriesBloc extends MockBloc<dynamic, TvState>
    implements TopRatedTvSeriesBloc {}

void main() {
  late MockTopRatedTvSeriesBloc mockBloc;

  setUp(() {
    mockBloc = MockTopRatedTvSeriesBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<TopRatedTvSeriesBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets('Page should display center progress bar when loading',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(TvLoading());

    await tester.pumpWidget(makeTestableWidget(TopRatedTvSeriesPage()));

    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.byType(Center), findsOneWidget);
  });

  testWidgets('Page should display ListView when data is loaded',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(TvHasData(const <TvSeries>[]));

    await tester.pumpWidget(makeTestableWidget(TopRatedTvSeriesPage()));

    expect(find.byType(ListView), findsOneWidget);
  });

  testWidgets('Page should display text with message when Error',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(TvError('Error message'));

    await tester.pumpWidget(makeTestableWidget(TopRatedTvSeriesPage()));

    expect(find.byKey(const Key('error_message')), findsOneWidget);
  });
}
