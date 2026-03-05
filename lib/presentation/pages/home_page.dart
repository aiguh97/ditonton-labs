import 'package:ditonton/presentation/pages/about_page.dart';
import 'package:ditonton/presentation/pages/movies/movie_list_page.dart';
import 'package:ditonton/presentation/pages/tv_series/tv_series_list_page.dart';
import 'package:ditonton/presentation/pages/watchlist_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _bottomNavIndex = 0;

  final List<BottomNavigationBarItem> _bottomNavBarItems = const [
    BottomNavigationBarItem(icon: Icon(Icons.movie), label: 'Movies'),
    BottomNavigationBarItem(
      icon: Icon(Icons.live_tv_outlined),
      label: 'TV Series',
    ),
    BottomNavigationBarItem(
      icon: Icon(Icons.remove_red_eye),
      label: 'Watchlist',
    ),
    BottomNavigationBarItem(icon: Icon(Icons.info_outline), label: 'About'),
  ];

  final List<Widget> _listWidget = [
    MovieListPage(),
    TvSeriesListPage(),
    WatchlistPage(),
    AboutPage(),
  ];

  void _onBottomNavTapped(int index) {
    setState(() {
      _bottomNavIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _listWidget[_bottomNavIndex],
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.bug_report),
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            builder: (context) => Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    leading: const Icon(Icons.analytics),
                    title: const Text('Send test analytics event'),
                    onTap: () async {
                      await FirebaseAnalytics.instance.logEvent(
                        name: 'test_event',
                        parameters: {'env': 'debug'},
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Sent test_event')),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.error_outline),
                    title: const Text('Send non-fatal to Crashlytics'),
                    onTap: () {
                      FirebaseCrashlytics.instance.recordError(
                        Exception('Test non-fatal from dev'),
                        StackTrace.current,
                        reason: 'testing crashlytics recordError',
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Sent non-fatal')),
                      );
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.warning),
                    title: const Text('Force crash (dev only)'),
                    onTap: () {
                      Navigator.pop(context);
                      // Force a crash for testing
                      FirebaseCrashlytics.instance.crash();
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _bottomNavIndex,
        items: _bottomNavBarItems,
        onTap: _onBottomNavTapped,
      ),
    );
  }
}
