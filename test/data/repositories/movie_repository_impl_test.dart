import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/movie_detail_model.dart';
import 'package:ditonton/data/models/movie_model.dart';
import 'package:ditonton/data/repositories/movie_repository_impl.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/movies/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late MovieRepositoryImpl repository;
  late MockMovieRemoteDataSource mockRemoteDataSource;
  late MockMovieLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockMovieRemoteDataSource();
    mockLocalDataSource = MockMovieLocalDataSource();

    repository = MovieRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tMovieModel = MovieModel(
    adult: false,
    backdropPath: '/path.jpg',
    genreIds: [1],
    id: 1,
    originalTitle: 'Spider Man',
    overview: 'overview',
    popularity: 1,
    posterPath: '/poster.jpg',
    releaseDate: '2002',
    title: 'Spider Man',
    video: false,
    voteAverage: 8,
    voteCount: 100,
  );

  final tMovie = Movie(
    adult: false,
    backdropPath: '/path.jpg',
    genreIds: [1],
    id: 1,
    originalTitle: 'Spider Man',
    overview: 'overview',
    popularity: 1,
    posterPath: '/poster.jpg',
    releaseDate: '2002',
    title: 'Spider Man',
    video: false,
    voteAverage: 8,
    voteCount: 100,
  );

  final tMovieModelList = <MovieModel>[tMovieModel];
  final tMovieList = <Movie>[tMovie];

  group('Now Playing Movies', () {
    test('should return movie list when call successful', () async {
      when(
        mockRemoteDataSource.getNowPlayingMovies(),
      ).thenAnswer((_) async => tMovieModelList);

      final result = await repository.getNowPlayingMovies();

      verify(mockRemoteDataSource.getNowPlayingMovies());

      final resultList = result.getOrElse(() => []);

      expect(resultList, tMovieList);
    });

    test('should return ServerFailure when exception occurs', () async {
      when(
        mockRemoteDataSource.getNowPlayingMovies(),
      ).thenThrow(ServerException());

      final result = await repository.getNowPlayingMovies();

      expect(result, Left(ServerFailure('Server Failure')));
    });

    test('should return ConnectionFailure when device offline', () async {
      when(
        mockRemoteDataSource.getNowPlayingMovies(),
      ).thenThrow(SocketException('Failed to connect'));

      final result = await repository.getNowPlayingMovies();

      expect(result, Left(ConnectionFailure('Failed to connect')));
    });
  });

  group('Popular Movies', () {
    test('should return movie list when successful', () async {
      when(
        mockRemoteDataSource.getPopularMovies(),
      ).thenAnswer((_) async => tMovieModelList);

      final result = await repository.getPopularMovies();

      final resultList = result.getOrElse(() => []);

      expect(resultList, tMovieList);
    });

    test('should return ServerFailure when error', () async {
      when(
        mockRemoteDataSource.getPopularMovies(),
      ).thenThrow(ServerException());

      final result = await repository.getPopularMovies();

      expect(result, Left(ServerFailure('Server Failure')));
    });

    test('should return ConnectionFailure when offline', () async {
      when(
        mockRemoteDataSource.getPopularMovies(),
      ).thenThrow(SocketException('Failed to connect'));

      final result = await repository.getPopularMovies();

      expect(result, Left(ConnectionFailure('Failed to connect')));
    });
  });

  group('Top Rated Movies', () {
    test('should return movie list when successful', () async {
      when(
        mockRemoteDataSource.getTopRatedMovies(),
      ).thenAnswer((_) async => tMovieModelList);

      final result = await repository.getTopRatedMovies();

      final resultList = result.getOrElse(() => []);

      expect(resultList, tMovieList);
    });

    test('should return ServerFailure when exception occurs', () async {
      when(
        mockRemoteDataSource.getTopRatedMovies(),
      ).thenThrow(ServerException());

      final result = await repository.getTopRatedMovies();

      expect(result, Left(ServerFailure('Server Failure')));
    });

    test('should return ConnectionFailure when offline', () async {
      when(
        mockRemoteDataSource.getTopRatedMovies(),
      ).thenThrow(SocketException('Failed to connect'));

      final result = await repository.getTopRatedMovies();

      expect(result, Left(ConnectionFailure('Failed to connect')));
    });
  });

  group('Movie Detail', () {
    final tId = 1;

    final tResponse = MovieDetailResponse(
      adult: false,
      backdropPath: '/path.jpg',
      budget: 100,
      genres: [GenreModel(id: 1, name: 'Action')],
      homepage: '',
      id: 1,
      imdbId: 'imdb',
      originalLanguage: 'en',
      originalTitle: 'Original Title',
      overview: 'Overview of the movie',
      popularity: 1,
      posterPath: '/path.jpg',
      releaseDate: '2020-05-05',
      revenue: 1,
      runtime: 120,
      status: 'Released',
      tagline: 'tagline',
      title: 'Title',
      video: false,
      voteAverage: 1.0,
      voteCount: 1,
    );
    test('should return movie detail when successful', () async {
      when(
        mockRemoteDataSource.getMovieDetail(tId),
      ).thenAnswer((_) async => tResponse);

      final result = await repository.getMovieDetail(tId);

      verify(mockRemoteDataSource.getMovieDetail(tId));

      expect(result, Right(testMovieDetail));
    });

    test('should return ServerFailure when exception occurs', () async {
      when(
        mockRemoteDataSource.getMovieDetail(tId),
      ).thenThrow(ServerException());

      final result = await repository.getMovieDetail(tId);

      expect(result, Left(ServerFailure('Server Failure')));
    });
  });

  group('Movie Recommendations', () {
    final tId = 1;

    test('should return list when successful', () async {
      when(
        mockRemoteDataSource.getMovieRecommendations(tId),
      ).thenAnswer((_) async => tMovieModelList);

      final result = await repository.getMovieRecommendations(tId);

      final resultList = result.getOrElse(() => []);

      expect(resultList, tMovieList);
    });

    test('should return ServerFailure when exception occurs', () async {
      when(
        mockRemoteDataSource.getMovieRecommendations(tId),
      ).thenThrow(ServerException());

      final result = await repository.getMovieRecommendations(tId);

      expect(result, Left(ServerFailure('Server Failure')));
    });
  });

  group('Search Movies', () {
    const query = 'spiderman';

    test('should return list when successful', () async {
      when(
        mockRemoteDataSource.searchMovies(query),
      ).thenAnswer((_) async => tMovieModelList);

      final result = await repository.searchMovies(query);

      final resultList = result.getOrElse(() => []);

      expect(resultList, tMovieList);
    });
  });

  group('Watchlist', () {
    test('should return success when save watchlist successful', () async {
      when(
        mockLocalDataSource.insertWatchlist(testMovieTable),
      ).thenAnswer((_) async => 'Added to Watchlist');

      final result = await repository.saveWatchlist(testMovieDetail);

      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when save failed', () async {
      when(
        mockLocalDataSource.insertWatchlist(testMovieTable),
      ).thenThrow(DatabaseException('Failed'));

      final result = await repository.saveWatchlist(testMovieDetail);

      expect(result, Left(DatabaseFailure('Failed')));
    });

    test('should return success when remove watchlist', () async {
      when(
        mockLocalDataSource.removeWatchlist(testMovieTable),
      ).thenAnswer((_) async => 'Removed');

      final result = await repository.removeWatchlist(testMovieDetail);

      expect(result, Right('Removed'));
    });
  });
}
