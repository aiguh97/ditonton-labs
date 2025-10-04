import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ditonton/presentation/provider/tv_series.dart';
import 'package:ditonton/presentation/widgets/tv_card.dart';
import 'package:ditonton/common/state_enum.dart';

class TvSeriesPage extends StatefulWidget {
  static const ROUTE_NAME = '/tv-series';
  const TvSeriesPage({super.key});

  @override
  State<TvSeriesPage> createState() => _TvSeriesPageState();
}

class _TvSeriesPageState extends State<TvSeriesPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(
      () =>
          Provider.of<TVSeriesNotifier>(context, listen: false).fetchTVSeries(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('TV Series')),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Consumer<TVSeriesNotifier>(
          builder: (context, notifier, child) {
            return Column(
              children: [
                // Search bar
                TextField(
                  controller: _controller,
                  decoration: const InputDecoration(
                    hintText: 'Search TV Series',
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(),
                  ),
                  onChanged: (query) {
                    notifier.search(query);
                  },
                ),
                const SizedBox(height: 8),
                // Content
                Expanded(
                  child: () {
                    if (notifier.state == RequestState.Loading) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (notifier.state == RequestState.Loaded) {
                      return ListView.builder(
                        itemCount: notifier.tvSeries.length,
                        itemBuilder: (context, index) {
                          final tv = notifier.tvSeries[index];
                          return TVSeriesCard(tv);
                        },
                      );
                    } else if (notifier.state == RequestState.Error) {
                      return Center(child: Text(notifier.message));
                    } else {
                      return const SizedBox();
                    }
                  }(),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
