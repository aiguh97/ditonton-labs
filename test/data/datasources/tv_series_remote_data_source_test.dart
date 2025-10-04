import 'dart:convert';

import 'package:ditonton/common/exception.dart';
import 'package:ditonton/data/datasources/tv_series_remote_data_source.dart';
import 'package:ditonton/data/models/tv_series_detail_model.dart';
import 'package:ditonton/data/models/tv_series_response.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

import '../../helpers/test_helper.mocks.dart';
import '../../json_reader.dart';

void main() {
  const API_KEY = 'api_key=3597c3452c08c649357f82941742287f';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late TvSeriesRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = TvSeriesRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get Now Playing TV Series', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/tv_series/now_playing.json')),
    ).tvSeriesList;

    test(
      'should return list of TV Series Model when response code is 200',
      () async {
        // arrange
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(
            readJson('dummy_data/tv_series/now_playing.json'),
            200,
          ),
        );
        // act
        final result = await dataSource.getNowPlayingTvSeries();
        // assert
        expect(result, equals(tTvSeriesList));
      },
    );

    test(
      'should throw ServerException when response code is not 200',
      () async {
        // arrange
        when(
          mockHttpClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        // act & assert
        await expectLater(
          dataSource.getNowPlayingTvSeries(),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });

  group('get Popular TV Series', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/tv_series/popular.json')),
    ).tvSeriesList;

    test(
      'should return list of TV Series Model when response code is 200',
      () async {
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async =>
              http.Response(readJson('dummy_data/tv_series/popular.json'), 200),
        );
        final result = await dataSource.getPopularTvSeries();
        expect(result, equals(tTvSeriesList));
      },
    );

    test(
      'should throw ServerException when response code is not 200',
      () async {
        when(
          mockHttpClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        await expectLater(
          dataSource.getPopularTvSeries(),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });

  group('get Top Rated TV Series', () {
    final tTvSeriesList = TvSeriesResponse.fromJson(
      json.decode(readJson('dummy_data/tv_series/top_rated.json')),
    ).tvSeriesList;

    test(
      'should return list of TV Series Model when response code is 200',
      () async {
        when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
          (_) async => http.Response(
            readJson('dummy_data/tv_series/top_rated.json'),
            200,
          ),
        );
        final result = await dataSource.getTopRatedTvSeries();
        expect(result, equals(tTvSeriesList));
      },
    );

    test(
      'should throw ServerException when response code is not 200',
      () async {
        when(
          mockHttpClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        await expectLater(
          dataSource.getTopRatedTvSeries(),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });

  group('search TV Series', () {
    final tSearchResult = TvSeriesResponse.fromJson(
      json.decode(
        readJson('dummy_data/tv_series/search_example_tv_series.json'),
      ),
    ).tvSeriesList;
    final tQuery = 'Game of Thrones';

    test('should return list of TV Series when response code is 200', () async {
      when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(
          readJson('dummy_data/tv_series/search_example_tv_series.json'),
          200,
        ),
      );
      final result = await dataSource.searchTvSeries(tQuery);
      expect(result, equals(tSearchResult));
    });

    test(
      'should throw ServerException when response code is not 200',
      () async {
        when(
          mockHttpClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        await expectLater(
          dataSource.searchTvSeries(tQuery),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });

  group('get TV Series Detail', () {
    final tId = 1;
    final tTvSeriesDetail = TvSeriesDetailResponse.fromJson(
      json.decode(readJson('dummy_data/tv_series/tv_series_detail.json')),
    );

    test('should return TV Series Detail when response code is 200', () async {
      when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(
          readJson('dummy_data/tv_series/tv_series_detail.json'),
          200,
        ),
      );
      final result = await dataSource.getTvSeriesDetail(tId);
      expect(result, equals(tTvSeriesDetail));
    });

    test(
      'should throw ServerException when response code is not 200',
      () async {
        when(
          mockHttpClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        await expectLater(
          dataSource.getTvSeriesDetail(tId),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });

  group('get TV Series Recommendations', () {
    final tId = 1;
    final tTvSeriesList = TvSeriesResponse.fromJson(
      json.decode(
        readJson('dummy_data/tv_series/tv_series_recommendations.json'),
      ),
    ).tvSeriesList;

    test('should return list of TV Series when response code is 200', () async {
      when(mockHttpClient.get(any, headers: anyNamed('headers'))).thenAnswer(
        (_) async => http.Response(
          readJson('dummy_data/tv_series/tv_series_recommendations.json'),
          200,
        ),
      );
      final result = await dataSource.getTvSeriesRecommendations(tId);
      expect(result, equals(tTvSeriesList));
    });

    test(
      'should throw ServerException when response code is not 200',
      () async {
        when(
          mockHttpClient.get(any, headers: anyNamed('headers')),
        ).thenAnswer((_) async => http.Response('Not Found', 404));
        await expectLater(
          dataSource.getTvSeriesRecommendations(tId),
          throwsA(isA<ServerException>()),
        );
      },
    );
  });
}
