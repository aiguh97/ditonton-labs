import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/bloc/tv_series/watchlist_tv_series/watchlist_tv_series_bloc.dart';
import 'package:ditonton/presentation/pages/tv_series/tv_series_detail_page.dart';
import 'package:ditonton/presentation/widgets/card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/watchlist-tv-series';

  @override
  State<WatchlistTvSeriesPage> createState() => _WatchlistTvSeriesPageState();
}

class _WatchlistTvSeriesPageState extends State<WatchlistTvSeriesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
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
    context.read<WatchlistTvSeriesBloc>().add(
      const FetchWatchlistTvSeriesEvent(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 8),
      child: BlocBuilder<WatchlistTvSeriesBloc, WatchlistTvSeriesState>(
        builder: (context, state) {
          if (state is WatchlistTvSeriesLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is WatchlistTvSeriesLoaded) {
            final data = state.tvSeries;

            return ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, index) {
                final tvSeries = data[index];

                return CardList(
                  title: tvSeries.name ?? '-',
                  overview: tvSeries.overview ?? '-',
                  posterPath: '${tvSeries.posterPath}',
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      TvSeriesDetailPage.ROUTE_NAME,
                      arguments: tvSeries.id,
                    );
                  },
                );
              },
            );
          }

          if (state is WatchlistTvSeriesError) {
            return Center(
              key: const Key('error_message'),
              child: Text(state.message),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }
}
