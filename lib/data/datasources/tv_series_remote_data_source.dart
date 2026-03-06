import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/models/tv_series_detail_model.dart';
import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/data/models/tv_series_response.dart';
import 'package:http/http.dart' as http;

abstract class TvSeriesRemoteDataSource {
  Future<List<TvSeriesModel>> getNowPlayingTvSeries();
  Future<List<TvSeriesModel>> getPopularTvSeries();
  Future<List<TvSeriesModel>> getTopRatedTvSeries();
  Future<List<TvSeriesModel>> searchTvSeries(String query);
  Future<TvSeriesDetailResponse> getTvSeriesDetail(int id);
  Future<List<TvSeriesModel>> getTvSeriesRecommendations(int id);
}

class TvSeriesRemoteDataSourceImpl implements TvSeriesRemoteDataSource {
  static const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  static const BASE_URL = 'https://api.themoviedb.org/3';

  final http.Client client;

  TvSeriesRemoteDataSourceImpl({required this.client});

  @override
  Future<List<TvSeriesModel>> getNowPlayingTvSeries() async {
    try {
      final response = await client.get(
        Uri.parse('$BASE_URL/tv/on_the_air?$API_KEY'),
      );

      if (response.statusCode == 200) {
        return TvSeriesResponse.fromJson(
          json.decode(response.body),
        ).tvSeriesList;
      } else {
        print(
          '[TvSeriesRemote] getNowPlayingTvSeries error: status=${response.statusCode} body=${response.body}',
        );
        throw ServerException();
      }
    } on SocketException catch (e) {
      print(
        '[TvSeriesRemote] SocketException getNowPlayingTvSeries: ${e.message}',
      );
      throw SocketException(e.message);
    } on TimeoutException {
      print('[TvSeriesRemote] TimeoutException getNowPlayingTvSeries');
      throw SocketException('Connection timed out');
    }
  }

  @override
  Future<List<TvSeriesModel>> getPopularTvSeries() async {
    try {
      final response = await client
          .get(Uri.parse('$BASE_URL/tv/popular?$API_KEY'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return TvSeriesResponse.fromJson(
          json.decode(response.body),
        ).tvSeriesList;
      } else {
        print(
          '[TvSeriesRemote] getPopularTvSeries error: status=${response.statusCode} body=${response.body}',
        );
        throw ServerException();
      }
    } on SocketException catch (e) {
      print(
        '[TvSeriesRemote] SocketException getPopularTvSeries: ${e.message}',
      );
      throw SocketException(e.message);
    } on TimeoutException {
      print('[TvSeriesRemote] TimeoutException getPopularTvSeries');
      throw SocketException('Connection timed out');
    }
  }

  @override
  Future<List<TvSeriesModel>> getTopRatedTvSeries() async {
    try {
      final response = await client
          .get(Uri.parse('$BASE_URL/tv/top_rated?$API_KEY'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return TvSeriesResponse.fromJson(
          json.decode(response.body),
        ).tvSeriesList;
      } else {
        print(
          '[TvSeriesRemote] getTopRatedTvSeries error: status=${response.statusCode} body=${response.body}',
        );
        throw ServerException();
      }
    } on SocketException catch (e) {
      print(
        '[TvSeriesRemote] SocketException getTopRatedTvSeries: ${e.message}',
      );
      throw SocketException(e.message);
    } on TimeoutException {
      print('[TvSeriesRemote] TimeoutException getTopRatedTvSeries');
      throw SocketException('Connection timed out');
    }
  }

  @override
  Future<List<TvSeriesModel>> searchTvSeries(String query) async {
    try {
      final response = await client
          .get(Uri.parse('$BASE_URL/search/tv?$API_KEY&query=$query'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return TvSeriesResponse.fromJson(
          json.decode(response.body),
        ).tvSeriesList;
      } else {
        throw ServerException();
      }
    } on SocketException catch (e) {
      throw SocketException(e.message);
    } on TimeoutException {
      throw SocketException('Connection timed out');
    }
  }

  @override
  Future<TvSeriesDetailResponse> getTvSeriesDetail(int id) async {
    try {
      final response = await client
          .get(Uri.parse('$BASE_URL/tv/$id?$API_KEY'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return TvSeriesDetailResponse.fromJson(json.decode(response.body));
      } else {
        throw ServerException();
      }
    } on SocketException catch (e) {
      throw SocketException(e.message);
    } on TimeoutException {
      throw SocketException('Connection timed out');
    }
  }

  @override
  Future<List<TvSeriesModel>> getTvSeriesRecommendations(int id) async {
    try {
      final response = await client
          .get(Uri.parse('$BASE_URL/tv/$id/recommendations?$API_KEY'))
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200) {
        return TvSeriesResponse.fromJson(
          json.decode(response.body),
        ).tvSeriesList;
      } else {
        throw ServerException();
      }
    } on SocketException catch (e) {
      throw SocketException(e.message);
    } on TimeoutException {
      throw SocketException('Connection timed out');
    }
  }
}
