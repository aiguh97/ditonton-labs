import 'package:flutter/foundation.dart';
import 'package:ditonton/common/state_enum.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/usecases/get_tv_series.dart';
import 'package:ditonton/domain/usecases/search_tv_series.dart';

class TVSeriesNotifier extends ChangeNotifier {
  final GetTVSeries getTVSeries;
  final SearchTVSeries searchTVSeries;

  TVSeriesNotifier({required this.getTVSeries, required this.searchTVSeries});

  RequestState _state = RequestState.Empty;
  RequestState get state => _state;

  List<TVSeries> _tvSeries = [];
  List<TVSeries> get tvSeries => _tvSeries;

  String _message = '';
  String get message => _message;

  bool _isSearching = false;
  bool get isSearching => _isSearching;

  Future<void> fetchTVSeries() async {
    _state = RequestState.Loading;
    notifyListeners();

    final result = await getTVSeries.execute();

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
      },
      (tvData) {
        _tvSeries = tvData;
        _state = RequestState.Loaded;
      },
    );
    notifyListeners();
  }

  Future<void> search(String query) async {
    if (query.isEmpty) {
      _isSearching = false;
      return fetchTVSeries();
    }

    _isSearching = true;
    _state = RequestState.Loading;
    notifyListeners();

    final result = await searchTVSeries.execute(query);

    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.Error;
      },
      (tvData) {
        _tvSeries = tvData;
        _state = RequestState.Loaded;
      },
    );
    notifyListeners();
  }
}
