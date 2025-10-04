import 'package:dartz/dartz.dart';
import 'package:ditonton/common/exception.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/common/network_info.dart';
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/domain/entities/tv.dart';
import 'package:ditonton/domain/repositories/tv_repository.dart';

class TVRepositoryImpl implements TVRepository {
  final TVRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  TVRepositoryImpl({required this.remoteDataSource, required this.networkInfo});

  @override
  Future<Either<Failure, List<TVSeries>>> getTVSeries() async {
    if (await networkInfo.isConnected) {
      try {
        final tvModels = await remoteDataSource.getTVSeries();
        final tvEntities = tvModels.map((model) => model.toEntity()).toList();
        return Right(tvEntities);
      } on ServerException {
        return Left(ServerFailure('Failed to fetch TV Series from server'));
      }
    } else {
      return Left(ConnectionFailure('No Internet Connection'));
    }
  }

  @override
  Future<Either<Failure, List<TVSeries>>> searchTVSeries(String query) async {
    if (await networkInfo.isConnected) {
      try {
        final tvModels = await remoteDataSource.searchTVSeries(query);
        final tvEntities = tvModels.map((model) => model.toEntity()).toList();
        return Right(tvEntities);
      } on ServerException {
        return Left(ServerFailure('Failed to search TV Series'));
      }
    } else {
      return Left(ConnectionFailure('No Internet Connection'));
    }
  }
}
