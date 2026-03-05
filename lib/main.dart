import 'package:ditonton/common/constants.dart';
import 'package:ditonton/firebase_options.dart';
import 'package:ditonton/presentation/bloc/movie/movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/movie_recommendation_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/movie_search_bloc.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie__detail_bloc.dart';
import 'package:ditonton/presentation/bloc/movie_detail/movie_detail_event.dart';
import 'package:ditonton/presentation/pages/home_page.dart';
import 'package:ditonton/presentation/pages/movies/movie_detail_page.dart';
import 'package:ditonton/presentation/pages/movies/popular_movies_page.dart';
import 'package:ditonton/presentation/pages/movies/search_movies_page.dart';
import 'package:ditonton/presentation/pages/movies/top_rated_movies_page.dart';
import 'package:ditonton/presentation/pages/movies/watchlist_movies_page.dart';
import 'package:ditonton/presentation/pages/tv_series/now_playing_tv_series_page.dart';
import 'package:ditonton/presentation/pages/tv_series/popular_tv_series_page.dart';
import 'package:ditonton/presentation/pages/tv_series/search_tv_series_page.dart';
import 'package:ditonton/presentation/pages/tv_series/top_rated_tv_series_page.dart';
import 'package:ditonton/presentation/pages/tv_series/tv_series_detail_page.dart';
import 'package:ditonton/presentation/pages/tv_series/tv_series_list_page.dart';
import 'package:ditonton/presentation/bloc/tv/tv_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/tv_event.dart';
import 'package:ditonton/presentation/bloc/tv/tv_search_bloc.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist_tv_series_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series_detail/tv_series_detail_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ditonton/injection.dart' as di;
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  di.init();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;
  static FirebaseAnalyticsObserver observer = FirebaseAnalyticsObserver(
    analytics: analytics,
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Ditonton',
      theme: ThemeData.dark().copyWith(
        colorScheme: kColorScheme,
        primaryColor: kRichBlack,
        scaffoldBackgroundColor: kRichBlack,
        textTheme: kTextTheme,
      ),
      home: BlocProvider(
        create: (_) =>
            di.locator<NowPlayingMovieBloc>()..add(FetchNowPlayingMovies()),
        child: HomePage(),
      ),
      navigatorObservers: [observer],
      onGenerateRoute: (RouteSettings settings) {
        switch (settings.name) {
          // ================= MOVIE =================

          case PopularMoviesPage.ROUTE_NAME:
            return MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) =>
                    di.locator<PopularMovieBloc>()..add(FetchPopularMovies()),
                child: PopularMoviesPage(),
              ),
            );

          case TopRatedMoviesPage.ROUTE_NAME:
            return MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) =>
                    di.locator<TopRatedMovieBloc>()..add(FetchTopRatedMovies()),
                child: TopRatedMoviesPage(),
              ),
            );

          case MovieDetailPage.ROUTE_NAME:
            final id = settings.arguments as int;
            return MaterialPageRoute(
              builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) =>
                        di.locator<MovieDetailBloc>()
                          ..add(FetchMovieDetailEvent(id)),
                  ),
                  BlocProvider(
                    create: (_) =>
                        di.locator<MovieRecommendationBloc>()
                          ..add(FetchMovieRecommendations(id)),
                  ),
                ],
                child: MovieDetailPage(id: id),
              ),
            );

          case SearchMoviesPage.ROUTE_NAME:
            return MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => di.locator<MovieSearchBloc>(),
                child: SearchMoviesPage(),
              ),
            );

          case WatchlistMoviesPage.ROUTE_NAME:
            return MaterialPageRoute(
              builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (_) => di.locator<WatchlistMovieBloc>()
                      ..add(FetchWatchlistMoviesEvent()),
                  ),
                  BlocProvider(
                    create: (_) => di.locator<WatchlistTvSeriesBloc>()
                      ..add(FetchWatchlistTvSeriesEvent()),
                  ),
                ],
                child: WatchlistMoviesPage(),
              ),
            );

          // ================= TV SERIES =================
          case TvSeriesListPage.ROUTE_NAME:
            return MaterialPageRoute(
              builder: (_) => MultiBlocProvider(
                providers: [
                  BlocProvider(create: (_) => di.locator<NowPlayingTvSeriesBloc>()),
                  BlocProvider(create: (_) => di.locator<PopularTvSeriesBloc>()),
                  BlocProvider(create: (_) => di.locator<TopRatedTvSeriesBloc>()),
                ],
                child: TvSeriesListPage(),
              ),
            );

          case NowPlayingTvSeriesPage.ROUTE_NAME:
            return MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => di.locator<NowPlayingTvSeriesBloc>(),
                child: NowPlayingTvSeriesPage(),
              ),
            );

          case PopularTvSeriesPage.ROUTE_NAME:
            return MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => di.locator<PopularTvSeriesBloc>(),
                child: PopularTvSeriesPage(),
              ),
            );

          case TopRatedTvSeriesPage.ROUTE_NAME:
            return MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => di.locator<TopRatedTvSeriesBloc>(),
                child: TopRatedTvSeriesPage(),
              ),
            );

          case SearchTvSeriesPage.ROUTE_NAME:
            return MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => di.locator<TvSeriesSearchBloc>(),
                child: SearchTvSeriesPage(),
              ),
            );

          case TvSeriesDetailPage.ROUTE_NAME:
            final id = settings.arguments as int;
            return MaterialPageRoute(
              builder: (_) => BlocProvider(
                create: (_) => di.locator<TvSeriesDetailBloc>(),
                child: TvSeriesDetailPage(id: id),
              ),
            );

          default:
            return MaterialPageRoute(
              builder: (_) =>
                  Scaffold(body: Center(child: Text('Page not found :('))),
            );
        }
      },
    );
  }
}
