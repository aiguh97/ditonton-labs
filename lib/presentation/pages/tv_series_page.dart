// import 'package:ditonton/presentation/pages/movie_detail_page.dart';
// import 'package:ditonton/presentation/provider/tv_series_notifier.dart';
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'package:ditonton/presentation/widgets/tv_card.dart';
// import 'package:ditonton/common/state_enum.dart';
// import 'package:ditonton/domain/entities/tv.dart';
// import 'package:ditonton/domain/entities/detail_entity.dart';

// class TvSeriesPage extends StatefulWidget {
//   static const ROUTE_NAME = '/tv-series';
//   const TvSeriesPage({super.key});

//   @override
//   State<TvSeriesPage> createState() => _TvSeriesPageState();
// }

// class _TvSeriesPageState extends State<TvSeriesPage> {
//   final TextEditingController _controller = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     Future.microtask(
//       () =>
//           Provider.of<TVSeriesNotifier>(context, listen: false).fetchTVSeries(),
//     );
//   }

//   @override
//   void dispose() {
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('TV Series')),
//       body: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: Consumer<TVSeriesNotifier>(
//           builder: (context, notifier, child) {
//             Widget content;
//             switch (notifier.state) {
//               case RequestState.Loading:
//                 content = const Center(child: CircularProgressIndicator());
//                 break;
//               case RequestState.Loaded:
//                 content = ListView.builder(
//                   itemCount: notifier.tvSeries.length,
//                   itemBuilder: (context, index) {
//                     final TVSeries tv = notifier
//                         .tvSeries[index]; // ⚡ Gunakan tipe asli TVSeries
//                     return InkWell(
//                       onTap: () {
//                         Navigator.pushNamed(
//                           context,
//                           DetailPage.ROUTE_NAME,
//                           arguments: {
//                             'detail': tv as DetailEntity,
//                             'isMovie': false,
//                           },
//                         );
//                       },
//                       child: TVSeriesCard(tv),
//                     );
//                   },
//                 );
//                 break;
//               case RequestState.Error:
//                 content = Center(child: Text(notifier.message));
//                 break;
//               default:
//                 content = const SizedBox();
//             }

//             return Column(
//               children: [
//                 TextField(
//                   controller: _controller,
//                   decoration: const InputDecoration(
//                     hintText: 'Search TV Series',
//                     prefixIcon: Icon(Icons.search),
//                     border: OutlineInputBorder(),
//                   ),
//                   onChanged: (query) {
//                     notifier.search(query);
//                   },
//                 ),
//                 const SizedBox(height: 8),
//                 Expanded(child: content),
//               ],
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
