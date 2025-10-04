// Entity
class TVSeries {
  final int id;
  final String name;
  final String overview;
  final String posterPath;

  TVSeries({
    required this.id,
    required this.name,
    required this.overview,
    required this.posterPath,
  });
}

// Model
class TVSeriesModel extends TVSeries {
  TVSeriesModel({
    required int id,
    required String name,
    required String overview,
    required String posterPath,
  }) : super(id: id, name: name, overview: overview, posterPath: posterPath);

  factory TVSeriesModel.fromJson(Map<String, dynamic> json) => TVSeriesModel(
    id: json['id'],
    name: json['name'],
    overview: json['overview'],
    posterPath: json['poster_path'] ?? '',
  );

  TVSeries toEntity() {
    return TVSeries(
      id: id,
      name: name,
      overview: overview,
      posterPath: posterPath,
    );
  }
}
