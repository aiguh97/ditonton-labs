import 'dart:convert';
import 'package:ditonton/data/datasources/movie_remote_data_source.dart';
import 'package:ditonton/data/models/movie_detail_model.dart';
import 'package:ditonton/data/models/movie_response.dart';
import 'package:ditonton/common/exception.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import '../../json_reader.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  const API_KEY = 'api_key=2174d146bb9c0eab47529b2e77d6b526';
  const BASE_URL = 'https://api.themoviedb.org/3';

  late MovieRemoteDataSourceImpl dataSource;
  late MockHttpClient mockHttpClient;

  setUp(() {
    mockHttpClient = MockHttpClient();
    dataSource = MovieRemoteDataSourceImpl(client: mockHttpClient);
  });

  group('get Now Playing Movies', () {
    final tMovieList = MovieResponse.fromJson(
      json.decode(readJson('dummy_data/movies/now_playing.json')),
    ).movieList;

    test(
      'should return list of Movie Model when response code is 200',
      () async {
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/movie/now_playing?$API_KEY')),
        ).thenAnswer(
          (_) async => http.Response(
            readJson('dummy_data/movies/now_playing.json'),
            200,
          ),
        );

        final result = await dataSource.getNowPlayingMovies();
        expect(result, equals(tMovieList));
      },
    );

    test('should throw a ServerException when response code is 404', () async {
      when(
        mockHttpClient.get(Uri.parse('$BASE_URL/movie/now_playing?$API_KEY')),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getNowPlayingMovies();
      expect(() async => await call, throwsA(isA<ServerException>()));
    });
  });

  group('get Popular Movies', () {
    final tMovieList = MovieResponse.fromJson(
      json.decode(readJson('dummy_data/movies/popular.json')),
    ).movieList;

    test(
      'should return list of movies when response is success (200)',
      () async {
        when(
          mockHttpClient.get(Uri.parse('$BASE_URL/movie/popular?$API_KEY')),
        ).thenAnswer(
          (_) async =>
              http.Response(readJson('dummy_data/movies/popular.json'), 200),
        );

        final result = await dataSource.getPopularMovies();
        expect(result, tMovieList);
      },
    );

    test('should throw ServerException when response code is 404', () async {
      when(
        mockHttpClient.get(Uri.parse('$BASE_URL/movie/popular?$API_KEY')),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getPopularMovies();
      expect(() async => await call, throwsA(isA<ServerException>()));
    });
  });

  group('get Top Rated Movies', () {
    final tMovieList = MovieResponse.fromJson(
      json.decode(readJson('dummy_data/movies/top_rated.json')),
    ).movieList;

    test('should return list of movies when response code is 200', () async {
      when(
        mockHttpClient.get(Uri.parse('$BASE_URL/movie/top_rated?$API_KEY')),
      ).thenAnswer(
        (_) async =>
            http.Response(readJson('dummy_data/movies/top_rated.json'), 200),
      );

      final result = await dataSource.getTopRatedMovies();
      expect(result, tMovieList);
    });

    test(
      'should throw ServerException when response code is not 200',
      () async {
        when(
          mockHttpClient.get(any),
        ).thenAnswer((_) async => http.Response('Error', 500));

        final call = dataSource.getTopRatedMovies();
        expect(() async => await call, throwsA(isA<ServerException>()));
      },
    );
  });

  group('get movie detail', () {
    final tId = 1;
    final tMovieDetail = MovieDetailResponse.fromJson(
      json.decode(readJson('dummy_data/movies/movie_detail.json')),
    );

    test('should return movie detail when response code is 200', () async {
      when(mockHttpClient.get(any)).thenAnswer(
        (_) async =>
            http.Response(readJson('dummy_data/movies/movie_detail.json'), 200),
      );

      final result = await dataSource.getMovieDetail(tId);
      expect(result, equals(tMovieDetail));
    });

    test('should throw ServerException when response code is 404', () async {
      when(
        mockHttpClient.get(any),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getMovieDetail(tId);
      expect(() async => await call, throwsA(isA<ServerException>()));
    });
  });

  group('get movie recommendations', () {
    final tId = 1;
    final tMovieList = MovieResponse.fromJson(
      json.decode(readJson('dummy_data/movies/movie_recommendations.json')),
    ).movieList;

    test(
      'should return list of Movie Model when response code is 200',
      () async {
        when(mockHttpClient.get(any)).thenAnswer(
          (_) async => http.Response(
            readJson('dummy_data/movies/movie_recommendations.json'),
            200,
          ),
        );

        final result = await dataSource.getMovieRecommendations(tId);
        expect(result, equals(tMovieList));
      },
    );

    test('should throw ServerException when response code is 404', () async {
      when(
        mockHttpClient.get(any),
      ).thenAnswer((_) async => http.Response('Not Found', 404));

      final call = dataSource.getMovieRecommendations(tId);
      expect(() async => await call, throwsA(isA<ServerException>()));
    });
  });

  group('search movies', () {
    final tQuery = 'Spiderman';
    final tSearchResult = MovieResponse.fromJson(
      json.decode(readJson('dummy_data/movies/search_spiderman_movie.json')),
    ).movieList;

    test('should return list of movies when response code is 200', () async {
      when(mockHttpClient.get(any)).thenAnswer(
        (_) async => http.Response(
          readJson('dummy_data/movies/search_spiderman_movie.json'),
          200,
        ),
      );

      final result = await dataSource.searchMovies(tQuery);
      expect(result, tSearchResult);
    });

    test(
      'should throw ServerException when response code is other than 200',
      () async {
        when(
          mockHttpClient.get(any),
        ).thenAnswer((_) async => http.Response('Not Found', 404));

        final call = dataSource.searchMovies(tQuery);
        expect(() async => await call, throwsA(isA<ServerException>()));
      },
    );
  });
}
