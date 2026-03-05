import 'package:ditonton/common/utils.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/presentation/bloc/movies/watchlist_movie/watchlist_movie_bloc.dart';
import 'package:ditonton/presentation/bloc/tv_series/watchlist_tv_series/watchlist_tv_series_bloc.dart';
import 'package:ditonton/presentation/widgets/movie_card.dart';
import 'package:ditonton/presentation/widgets/tv_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      context.read<WatchlistMovieBloc>().add(const FetchWatchlistMoviesEvent());
      context.read<WatchlistTvSeriesBloc>().add(
        const FetchWatchlistTvSeriesEvent(),
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<WatchlistMovieBloc>().add(const FetchWatchlistMoviesEvent());
    context.read<WatchlistTvSeriesBloc>().add(
      const FetchWatchlistTvSeriesEvent(),
    );
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
      child: BlocBuilder<WatchlistMovieBloc, WatchlistMovieState>(
        builder: (context, state) {
          if (state is WatchlistMovieLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WatchlistMovieLoaded) {
            if (state.movies.isEmpty) {
              return const Center(child: Text('Watchlist film kosong.'));
            }
            return ListView.builder(
              itemCount: state.movies.length,
              itemBuilder: (context, index) {
                final movie = state.movies[index];
                return MovieCard(movie);
              },
            );
          } else if (state is WatchlistMovieError) {
            return Center(
              key: const Key('error_message_movie'),
              child: Text(state.message),
            );
          } else {
            return const Center(
              key: Key('error_message_movie'),
              child: Text('Unknown error'),
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
      child: BlocBuilder<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
        builder: (context, state) {
          if (state is WatchlistTvSeriesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is WatchlistTvSeriesLoaded) {
            if (state.tvSeries.isEmpty) {
              return const Center(child: Text('Watchlist TV Series kosong.'));
            }
            return ListView.builder(
              itemCount: state.tvSeries.length,
              itemBuilder: (context, index) {
                final tv = state.tvSeries[index];
                return TvCard(tv);
              },
            );
          } else if (state is WatchlistTvSeriesError) {
            return Center(
              key: const Key('error_message_tv'),
              child: Text(state.message),
            );
          } else {
            return const Center(
              key: Key('error_message_tv'),
              child: Text('Unknown error'),
            );
          }
        },
      ),
    );
  }
}
