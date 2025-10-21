import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/common/utils.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/provider/movies/watchlist_movie_notifier.dart';
import 'package:ditonton/presentation/provider/tv_series/watchlist_tv_series_notifier.dart';
import 'package:ditonton/presentation/widgets/movie_card.dart';
import 'package:ditonton/presentation/widgets/tv_card.dart';
// import 'package:ditonton/presentation/widgets/tv_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WatchlistMoviesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-movie';

  const WatchlistMoviesPage({super.key});

  @override
  _WatchlistPageState createState() => _WatchlistPageState();
}

class _WatchlistPageState extends State<WatchlistMoviesPage> with RouteAware {
  @override
  void initState() {
    super.initState();
    // Fetch data untuk kedua tab (movie & tv series)
    Future.microtask(() {
      Provider.of<WatchlistMovieNotifier>(
        context,
        listen: false,
      ).fetchWatchlistMovies();
      Provider.of<WatchlistTvSeriesNotifier>(
        context,
        listen: false,
      ).fetchWatchlistTvSeries();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    Provider.of<WatchlistMovieNotifier>(
      context,
      listen: false,
    ).fetchWatchlistMovies();
    Provider.of<WatchlistTvSeriesNotifier>(
      context,
      listen: false,
    ).fetchWatchlistTvSeries();
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, // dua tab
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Watchlist'),
          bottom: const TabBar(
            dividerColor: Colors.transparent,
            tabs: [
              Tab(text: 'Movies'),
              Tab(text: 'TV Series'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [_WatchlistMovieTab(), _WatchlistTvTab()],
        ),
      ),
    );
  }
}

// 🔹 Tab 1: Watchlist Movie
class _WatchlistMovieTab extends StatelessWidget {
  const _WatchlistMovieTab();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer<WatchlistMovieNotifier>(
        builder: (context, data, child) {
          if (data.watchlistState == RequestState.Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (data.watchlistState == RequestState.Loaded) {
            if (data.watchlistMovies.isEmpty) {
              return const Center(child: Text('Watchlist film kosong.'));
            }
            return ListView.builder(
              itemCount: data.watchlistMovies.length,
              itemBuilder: (context, index) {
                final movie = data.watchlistMovies[index];
                return MovieCard(movie);
              },
            );
          } else {
            return Center(
              key: const Key('error_message_movie'),
              child: Text(data.message),
            );
          }
        },
      ),
    );
  }
}

// 🔹 Tab 2: Watchlist TV
class _WatchlistTvTab extends StatelessWidget {
  const _WatchlistTvTab();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Consumer<WatchlistTvSeriesNotifier>(
        builder: (context, data, child) {
          if (data.watchlistState == RequestState.Loading) {
            return const Center(child: CircularProgressIndicator());
          } else if (data.watchlistState == RequestState.Loaded) {
            if (data.watchlistTvSeries.isEmpty) {
              return const Center(child: Text('Watchlist TV Series kosong.'));
            }
            return ListView.builder(
              itemCount: data.watchlistTvSeries.length,
              itemBuilder: (context, index) {
                final tv = data.watchlistTvSeries[index];
                return TvCard(tv);
                // return MovieCard(tv as Movie);
              },
            );
          } else {
            return Center(
              key: const Key('error_message_tv'),
              child: Text(data.message),
            );
          }
        },
      ),
    );
  }
}
