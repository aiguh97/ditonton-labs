import 'package:bloc_test/bloc_test.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie__detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_state.dart';
import 'package:ditonton/presentation/pages/movies/movie_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import '../../../dummy_data/movies/dummy_objects.dart';

class MockMovieDetailBloc extends MockBloc<dynamic, MovieDetailState>
    implements MovieDetailBloc {}

void main() {
  late MockMovieDetailBloc mockBloc;

  setUp(() {
    mockBloc = MockMovieDetailBloc();
  });

  Widget makeTestableWidget(Widget body) {
    return BlocProvider<MovieDetailBloc>.value(
      value: mockBloc,
      child: MaterialApp(home: body),
    );
  }

  testWidgets(
      'Watchlist button should display add icon when movie not added to watchlist',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(
      MovieDetailLoaded(testMovieDetail, const <Movie>[]),
    );

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
    await tester.pump();

    expect(find.byIcon(Icons.add), findsOneWidget);
  });

  testWidgets(
      'Watchlist button should display check icon when movie is added to watchlist',
      (WidgetTester tester) async {
    when(() => mockBloc.state).thenReturn(
      MovieDetailLoaded(testMovieDetail, const <Movie>[]),
    );
    // Emit WatchlistStatusLoaded=true on the next state emission
    whenListen(
      mockBloc,
      Stream.fromIterable([WatchlistStatusLoaded(true)]),
    );

    await tester.pumpWidget(makeTestableWidget(MovieDetailPage(id: 1)));
    await tester.pump();

    expect(find.byIcon(Icons.check), findsOneWidget);
  });
}
