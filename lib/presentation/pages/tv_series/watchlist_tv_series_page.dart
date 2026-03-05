import 'package:ditonton/common/utils.dart';
import 'package:ditonton/presentation/bloc/tv/tv_event.dart';
import 'package:ditonton/presentation/bloc/tv/tv_state.dart';
import 'package:ditonton/presentation/bloc/tv/watchlist_tv_series_bloc.dart';
import 'package:ditonton/presentation/pages/tv_series/tv_series_detail_page.dart';
import 'package:ditonton/presentation/widgets/card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WatchlistTvSeriesPage extends StatefulWidget {
  @override
  _WatchlistTvSeriesPageState createState() => _WatchlistTvSeriesPageState();
}

class _WatchlistTvSeriesPageState extends State<WatchlistTvSeriesPage>
    with RouteAware {
  @override
  void initState() {
    super.initState();
    Future.microtask(() =>
        context.read<WatchlistTvSeriesBloc>().add(FetchWatchlistTvSeriesEvent()));
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  void didPopNext() {
    context.read<WatchlistTvSeriesBloc>().add(FetchWatchlistTvSeriesEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, left: 8, right: 8, bottom: 8),
      child: BlocBuilder<WatchlistTvSeriesBloc, TvState>(
        builder: (context, state) {
          if (state is TvLoading) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is TvHasData) {
            return ListView.builder(
              itemBuilder: (context, index) {
                final tvSeries = state.result[index];
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
              itemCount: state.result.length,
            );
          } else if (state is TvError) {
            return Center(
              key: Key('error_message'),
              child: Text(state.message),
            );
          } else {
            return Container();
          }
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
