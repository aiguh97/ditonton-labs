import 'package:ditonton/data/models/movie_table.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/movie.dart';
import 'package:ditonton/domain/entities/movie_detail.dart';

final testMovie = Movie(
  adult: false,
  backdropPath: '/muth4OYamXf41G2evdrLEg8d3om.jpg',
  genreIds: [14, 28],
  id: 557,
  originalTitle: 'Spider-Man',
  overview:
      'After being bitten by a genetically altered spider, nerdy high school student Peter Parker is endowed with amazing powers to become the Amazing superhero known as Spider-Man.',
  popularity: 60.441,
  posterPath: '/rweIrveL43TaxUN0akQEaAXL6x0.jpg',
  releaseDate: '2002-05-01',
  title: 'Spider-Man',
  video: false,
  voteAverage: 7.2,
  voteCount: 13507,
);

final testMovieList = [testMovie];

final testMovieDetail = MovieDetail(
  adult: false,
  backdropPath: 'backdropPath',
  genres: [Genre(id: 1, name: 'Action')],
  id: 1,
  originalTitle: 'Original Title',
  overview: 'Overview of the movie',
  posterPath: 'posterPath',
  releaseDate: '2020-05-05',
  runtime: 120,
  title: 'Title',
  voteAverage: 1.0,
  voteCount: 1,
);

final testWatchlistMovie = Movie.watchlist(
  id: testMovieDetail.id,
  title: testMovieDetail.title,
  posterPath: testMovieDetail.posterPath,
  overview: testMovieDetail.overview,
);

final testMovieTable = MovieTable(
  id: testMovieDetail.id,
  title: testMovieDetail.title,
  posterPath: testMovieDetail.posterPath,
  overview: testMovieDetail.overview,
);

final testMovieMap = {
  'id': testMovieTable.id,
  'overview': testMovieTable.overview,
  'posterPath': testMovieTable.posterPath,
  'title': testMovieTable.title,
};

final testMovieJsonResponse = {
  "dates": {"maximum": "2021-05-23", "minimum": "2021-04-05"},
  "page": 1,
  "results": [
    {
      "adult": false,
      "backdrop_path": "/path.jpg",
      "genre_ids": [1, 2, 3, 4],
      "id": 1,
      "original_language": "en",
      "original_title": "Original Title",
      "overview": "Overview of the movie",
      "popularity": 1.0,
      "poster_path": "/path.jpg",
      "release_date": "2020-05-05",
      "title": "Title",
      "video": false,
      "vote_average": 1.0,
      "vote_count": 1,
    },
  ],
  "total_pages": 47,
  "total_results": 940,
};
