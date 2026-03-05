import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/data/repositories/tv_series_repository_impl.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../dummy_data/tv_series/dummy_objects.dart';
import '../../helpers/test_helper.mocks.dart';

void main() {
  late TvSeriesRepositoryImpl repository;
  late MockTvSeriesRemoteDataSource mockRemoteDataSource;
  late MockTvSeriesLocalDataSource mockLocalDataSource;

  setUp(() {
    mockRemoteDataSource = MockTvSeriesRemoteDataSource();
    mockLocalDataSource = MockTvSeriesLocalDataSource();

    repository = TvSeriesRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
    );
  });

  final tTvSeriesModelList = <TvSeriesModel>[tTvSeriesModel];
  final tTvSeriesList = <TvSeries>[tTvSeries];

  group('Now Playing TV Series', () {
    test('should return tv series list when successful', () async {
      when(
        mockRemoteDataSource.getNowPlayingTvSeries(),
      ).thenAnswer((_) async => tTvSeriesModelList);

      final result = await repository.getNowPlayingTvSeries();

      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvSeriesList);
    });

    test('should return ServerFailure when exception occurs', () async {
      when(
        mockRemoteDataSource.getNowPlayingTvSeries(),
      ).thenThrow(ServerException());

      final result = await repository.getNowPlayingTvSeries();

      expect(result, equals(Left(ServerFailure('Server Failure'))));
    });

    test('should return ConnectionFailure when device offline', () async {
      when(
        mockRemoteDataSource.getNowPlayingTvSeries(),
      ).thenThrow(SocketException('Failed to connect to the network'));

      final result = await repository.getNowPlayingTvSeries();

      expect(
        result,
        Left(ConnectionFailure('Failed to connect to the network')),
      );
    });
  });

  group('Popular TV Series', () {
    test('should return tv series list when successful', () async {
      when(
        mockRemoteDataSource.getPopularTvSeries(),
      ).thenAnswer((_) async => tTvSeriesModelList);

      final result = await repository.getPopularTvSeries();

      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvSeriesList);
    });

    test('should return ServerFailure when exception occurs', () async {
      when(
        mockRemoteDataSource.getPopularTvSeries(),
      ).thenThrow(ServerException());

      final result = await repository.getPopularTvSeries();

      expect(result, Left(ServerFailure('Server Failure')));
    });

    test('should return ConnectionFailure when offline', () async {
      when(
        mockRemoteDataSource.getPopularTvSeries(),
      ).thenThrow(SocketException('Failed to connect to the network'));

      final result = await repository.getPopularTvSeries();

      expect(
        result,
        Left(ConnectionFailure('Failed to connect to the network')),
      );
    });
  });

  group('Top Rated TV Series', () {
    test('should return tv series list when successful', () async {
      when(
        mockRemoteDataSource.getTopRatedTvSeries(),
      ).thenAnswer((_) async => tTvSeriesModelList);

      final result = await repository.getTopRatedTvSeries();

      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvSeriesList);
    });

    test('should return ServerFailure when exception occurs', () async {
      when(
        mockRemoteDataSource.getTopRatedTvSeries(),
      ).thenThrow(ServerException());

      final result = await repository.getTopRatedTvSeries();

      expect(result, Left(ServerFailure('Server Failure')));
    });

    test('should return ConnectionFailure when offline', () async {
      when(
        mockRemoteDataSource.getTopRatedTvSeries(),
      ).thenThrow(SocketException('Failed to connect to the network'));

      final result = await repository.getTopRatedTvSeries();

      expect(
        result,
        Left(ConnectionFailure('Failed to connect to the network')),
      );
    });
  });

  group('Search TV Series', () {
    const query = 'game of thrones';

    test('should return tv series list when successful', () async {
      when(
        mockRemoteDataSource.searchTvSeries(query),
      ).thenAnswer((_) async => tTvSeriesModelList);

      final result = await repository.searchTvSeries(query);

      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvSeriesList);
    });

    test('should return ServerFailure when exception occurs', () async {
      when(
        mockRemoteDataSource.searchTvSeries(query),
      ).thenThrow(ServerException());

      final result = await repository.searchTvSeries(query);

      expect(result, Left(ServerFailure('Server Failure')));
    });

    test('should return ConnectionFailure when offline', () async {
      when(
        mockRemoteDataSource.searchTvSeries(query),
      ).thenThrow(SocketException('Failed to connect to the network'));

      final result = await repository.searchTvSeries(query);

      expect(
        result,
        Left(ConnectionFailure('Failed to connect to the network')),
      );
    });
  });

  group('Get TV Series Detail', () {
    final tId = 1;

    test('should return tv series detail when successful', () async {
      when(
        mockRemoteDataSource.getTvSeriesDetail(tId),
      ).thenAnswer((_) async => tTvSeriesResponse);

      final result = await repository.getTvSeriesDetail(tId);

      expect(result, Right(tTvSeriesDetail));
    });

    test('should return ServerFailure when exception occurs', () async {
      when(
        mockRemoteDataSource.getTvSeriesDetail(tId),
      ).thenThrow(ServerException());

      final result = await repository.getTvSeriesDetail(tId);

      expect(result, Left(ServerFailure('Server Failure')));
    });
  });

  group('Get TV Series Recommendations', () {
    final tId = 1;

    test('should return tv series list when successful', () async {
      when(
        mockRemoteDataSource.getTvSeriesRecommendations(tId),
      ).thenAnswer((_) async => tTvSeriesModelList);

      final result = await repository.getTvSeriesRecommendations(tId);

      final resultList = result.getOrElse(() => []);
      expect(resultList, tTvSeriesList);
    });

    test('should return ServerFailure when exception occurs', () async {
      when(
        mockRemoteDataSource.getTvSeriesRecommendations(tId),
      ).thenThrow(ServerException());

      final result = await repository.getTvSeriesRecommendations(tId);

      expect(result, Left(ServerFailure('Server Failure')));
    });
  });

  group('Save Watchlist', () {
    test('should return success when saving successful', () async {
      when(
        mockLocalDataSource.insertWatchlist(tTvSeriesTable),
      ).thenAnswer((_) async => 'Added to Watchlist');

      final result = await repository.saveWatchlist(tTvSeriesDetail);

      expect(result, Right('Added to Watchlist'));
    });

    test('should return DatabaseFailure when saving unsuccessful', () async {
      when(
        mockLocalDataSource.insertWatchlist(tTvSeriesTable),
      ).thenThrow(DatabaseException('Failed to add watchlist'));

      final result = await repository.saveWatchlist(tTvSeriesDetail);

      expect(result, Left(DatabaseFailure('Failed to add watchlist')));
    });
  });

  group('Remove Watchlist', () {
    test('should return success when remove successful', () async {
      when(
        mockLocalDataSource.removeWatchlist(tTvSeriesTable),
      ).thenAnswer((_) async => 'Removed from watchlist');

      final result = await repository.removeWatchlist(tTvSeriesDetail);

      expect(result, Right('Removed from watchlist'));
    });
  });

  group('Get Watchlist Status', () {
    test('should return false when tv series not found', () async {
      when(
        mockLocalDataSource.getTvSeriesById(1),
      ).thenAnswer((_) async => null);

      final result = await repository.isAddedToWatchlist(1);

      expect(result, false);
    });
  });

  group('Get Watchlist TV Series', () {
    test('should return list of tv series', () async {
      when(
        mockLocalDataSource.getWatchlistTvSeries(),
      ).thenAnswer((_) async => [tTvSeriesTable]);

      final result = await repository.getWatchlistTvSeries();

      final resultList = result.getOrElse(() => []);
      expect(resultList, [tWatchlistTvSeries]);
    });
  });
}
