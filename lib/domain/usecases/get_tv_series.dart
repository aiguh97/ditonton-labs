import 'package:dartz/dartz.dart';
import 'package:ditonton/common/failure.dart';
import 'package:ditonton/data/datasources/tv_remote_data_source.dart';
import 'package:ditonton/domain/entities/tv.dart';

class GetTVSeries {
  final TVRemoteDataSource repository;

  GetTVSeries(this.repository);

  Future<Either<Failure, List<TVSeries>>> execute() async {
    try {
      final result = await repository.getTVSeries(); // List<TVSeriesModel>
      return Right(
        result.map((model) => model.toEntity()).toList(),
      ); // convert ke entity
    } catch (e) {
      return Left(ServerFailure('Failed to fetch TV series'));
    }
  }
}
