import 'package:ditonton/common/utils.dart';

import 'package:ditonton/presentation/bloc/movie/movie_event.dart';
import 'package:ditonton/presentation/bloc/movie/movie_state.dart';
import 'package:ditonton/presentation/bloc/movie/watchlist_movie_bloc.dart';

import 'package:ditonton/presentation/bloc/tv/tv_event.dart';
import 'package:ditonton/presentation/bloc/tv/tv_state.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist_tv_series_bloc.dart';
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
    Future.microtask(() {
      context.read<WatchlistMovieBloc>().add(FetchWatchlistMoviesEvent());
      context.read<WatchlistTvSeriesBloc>().add(FetchWatchlistTvSeriesEvent());
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void didPopNext() {
    context.read<WatchlistMovieBloc>().add(FetchWatchlistMoviesEvent());
    context.read<WatchlistTvSeriesBloc>().add(FetchWatchlistTvSeriesEvent());
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
      child: BlocBuilder<WatchlistMovieBloc, MovieState>(
        builder: (context, state) {
          if (state is MovieLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MovieHasData) {
            if (state.result.isEmpty) {
              return const Center(child: Text('Watchlist film kosong.'));
            }
            return ListView.builder(
              itemCount: state.result.length,
              itemBuilder: (context, index) {
                final movie = state.result[index];
                return MovieCard(movie);
              },
            );
          } else if (state is MovieError) {
            return Center(
              key: const Key('error_message_movie'),
              child: Text(state.message),
            );
          } else {
            return const SizedBox();
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
      child: BlocBuilder<WatchlistTvSeriesBloc, TvSeriesState>(
        builder: (context, state) {
          if (state is TvSeriesLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is TvSeriesHasData) {
            if (state.result.isEmpty) {
              return const Center(child: Text('Watchlist TV Series kosong.'));
            }
            return ListView.builder(
              itemCount: state.result.length,
              itemBuilder: (context, index) {
                final tv = state.result[index];
                return TvCard(tv);
              },
            );
          } else if (state is TvSeriesError) {
            return Center(
              key: const Key('error_message_tv'),
              child: Text(state.message),
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
