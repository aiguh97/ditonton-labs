import 'package:ditonton/presentation/bloc/tv_series/popular_tv_series/popular_tv_series_bloc.dart';
import 'package:ditonton/presentation/pages/tv_series/tv_series_detail_page.dart';
import 'package:ditonton/presentation/widgets/card_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class PopularTvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/popular-tv-series';

  @override
  _PopularTvSeriesPageState createState() => _PopularTvSeriesPageState();
}

class _PopularTvSeriesPageState extends State<PopularTvSeriesPage> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      context.read<PopularTvSeriesBloc>().add(FetchPopularTvSeriesEvent());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Popular TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: BlocBuilder<PopularTvSeriesBloc, PopularTvSeriesState>(
          builder: (context, state) {
            if (state is PopularTvSeriesLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is PopularTvSeriesLoaded) {
              return ListView.builder(
                itemCount: state.tvSeries.length,
                itemBuilder: (context, index) {
                  final tvSeries = state.tvSeries[index];

                  return CardList(
                    title: tvSeries.name ?? '-',
                    overview: tvSeries.overview ?? '-',
                    posterPath: tvSeries.posterPath ?? '',
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

            if (state is PopularTvSeriesError) {
              return Center(
                key: const Key('error_message'),
                child: Text(state.message),
              );
            }

            return const SizedBox();
          },
        ),
      ),
    );
  }
}
