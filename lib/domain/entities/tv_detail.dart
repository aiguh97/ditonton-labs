import 'package:equatable/equatable.dart';
import 'genre.dart';

class TVDetail extends Equatable {
  final int id;
  final String name;
  final String overview;
  final String posterPath;
  final double voteAverage;
  final int numberOfEpisodes;
  final int numberOfSeasons;
  final List<Genre> genres;

  TVDetail({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
    required this.voteAverage,
    required this.numberOfEpisodes,
    required this.numberOfSeasons,
    required this.genres,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    overview,
    posterPath,
    voteAverage,
    numberOfEpisodes,
    numberOfSeasons,
    genres,
  ];
}
