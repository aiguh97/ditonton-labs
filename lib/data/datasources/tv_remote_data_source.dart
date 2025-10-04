import 'dart:convert';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:http/http.dart' as http;

abstract class TVRemoteDataSource {
  Future<List<TVSeriesModel>> getTVSeries();

  Future<List<TVSeriesModel>> searchTVSeries(String query);
}

class TVRemoteDataSourceImpl implements TVRemoteDataSource {
  static const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  static const BASE_URL = 'https://api.themoviedb.org/3';
  final http.Client client;

  TVRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TVSeriesModel>> getTVSeries() async {
    final response = await client.get(
      Uri.parse('$BASE_URL/tv/popular?$API_KEY'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((json) => TVSeriesModel.fromJson(json))
          .toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<TVSeriesModel>> searchTVSeries(String query) async {
    final response = await client.get(
      Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$query'),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['results'] as List)
          .map((json) => TVSeriesModel.fromJson(json))
          .toList();
    } else {
      throw ServerException();
    }
  }
}
