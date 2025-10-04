import 'package:ditonton/data/models/genre_model.dart';
import 'package:ditonton/data/models/season_model.dart';
import 'package:ditonton/data/models/tv_series_detail_model.dart';
import 'package:ditonton/data/models/tv_series_model.dart';
import 'package:ditonton/data/models/tv_series_table.dart';
import 'package:ditonton/domain/entities/genre.dart';
import 'package:ditonton/domain/entities/season.dart';
import 'package:ditonton/domain/entities/tv_series.dart';
import 'package:ditonton/domain/entities/tv_series_detail.dart';

final tTvSeriesModel = TvSeriesModel(
  posterPath: '/jIhL6mlT7AblhbHJgEoiBIOUVl1.jpg',
  popularity: 29.780826,
  id: 1399,
  backdropPath: '/mUkuc2wyV9dHLG0D0Loaw5pO2s8.jpg',
  voteAverage: 7.91,
  overview:
      'Seven noble families fight for control of the mythical land of Westeros. Friction between the houses leads to full-scale war. All while a very ancient evil awakens in the farthest north.',
  firstAirDate: '2011-04-17',
  originCountry: ['US'],
  genreIds: [10765, 10759, 18],
  originalLanguage: 'en',
  voteCount: 1172,
  name: 'Game of Thrones',
  originalName: 'Game of Thrones',
);

final tTvSeries = TvSeries(
  posterPath: tTvSeriesModel.posterPath,
  popularity: tTvSeriesModel.popularity,
  id: tTvSeriesModel.id,
  backdropPath: tTvSeriesModel.backdropPath,
  voteAverage: tTvSeriesModel.voteAverage,
  overview: tTvSeriesModel.overview,
  firstAirDate: tTvSeriesModel.firstAirDate,
  originCountry: tTvSeriesModel.originCountry,
  genreIds: tTvSeriesModel.genreIds,
  originalLanguage: tTvSeriesModel.originalLanguage,
  voteCount: tTvSeriesModel.voteCount,
  name: tTvSeriesModel.name,
  originalName: tTvSeriesModel.originalName,
);

final tTvSeriesResponse = TvSeriesDetailResponse(
  backdropPath: 'backdropPath',
  firstAirDate: '2022-10-10',
  genres: [GenreModel(id: 1, name: 'Drama')],
  homepage: 'https://google.com',
  id: 1,
  inProduction: false,
  languages: ['en'],
  lastAirDate: '2022-10-10',
  name: 'Sample Series',
  numberOfEpisodes: 12,
  numberOfSeasons: 6,
  originCountry: ['US'],
  originalLanguage: 'en',
  originalName: 'Original Name',
  overview: 'Overview of the series',
  popularity: 369.0,
  posterPath: 'posterPath',
  seasons: [
    SeasonModel(
      airDate: '2022-10-10',
      episodeCount: 15,
      id: 1,
      name: 'Season 1',
      overview: 'Overview of season',
      posterPath: 'posterPath',
      seasonNumber: 1,
    ),
  ],
  status: 'Returning Series',
  tagline: 'Tagline here',
  type: 'Scripted',
  voteAverage: 8.3,
  voteCount: 1200,
);

final tTvSeriesDetail = TvSeriesDetail(
  backdropPath: tTvSeriesResponse.backdropPath,
  firstAirDate: tTvSeriesResponse.firstAirDate,
  genres: tTvSeriesResponse.genres
      .map((genre) => Genre(id: genre.id, name: genre.name))
      .toList(),
  id: tTvSeriesResponse.id,
  lastAirDate: tTvSeriesResponse.lastAirDate,
  name: tTvSeriesResponse.name,
  numberOfEpisodes: tTvSeriesResponse.numberOfEpisodes,
  numberOfSeasons: tTvSeriesResponse.numberOfSeasons,
  overview: tTvSeriesResponse.overview,
  posterPath: tTvSeriesResponse.posterPath,
  seasons: tTvSeriesResponse.seasons
      .map(
        (season) => Season(
          airDate: season.airDate,
          episodeCount: season.episodeCount,
          id: season.id,
          name: season.name,
          overview: season.overview,
          posterPath: season.posterPath,
          seasonNumber: season.seasonNumber,
        ),
      )
      .toList(),
  status: tTvSeriesResponse.status,
  tagline: tTvSeriesResponse.tagline,
  type: tTvSeriesResponse.type,
  voteAverage: tTvSeriesResponse.voteAverage,
  voteCount: tTvSeriesResponse.voteCount,
);

final tTvSeriesTable = TvSeriesTable(
  id: tTvSeriesDetail.id,
  name: tTvSeriesDetail.name,
  posterPath: tTvSeriesDetail.posterPath,
  overview: tTvSeriesDetail.overview,
);

final tTvSeriesMap = {
  'id': tTvSeriesTable.id,
  'overview': tTvSeriesTable.overview,
  'posterPath': tTvSeriesTable.posterPath,
  'name': tTvSeriesTable.name,
};

final tWatchlistTvSeries = TvSeries.watchlist(
  id: tTvSeriesDetail.id,
  name: tTvSeriesDetail.name,
  posterPath: tTvSeriesDetail.posterPath,
  overview: tTvSeriesDetail.overview,
);

final tTvSeriesJsonResponse = {
  "page": 1,
  "results": [
    {
      "poster_path": "/path.jpg",
      "popularity": 2.3,
      "id": 1,
      "backdrop_path": "/path.jpg",
      "vote_average": 8.0,
      "overview": "Overview",
      "first_air_date": "2022-10-10",
      "origin_country": ["US"],
      "genre_ids": [1, 2, 3],
      "original_language": "en",
      "vote_count": 230,
      "name": "Name",
      "original_name": "Original Name",
    },
  ],
  "total_results": 192,
  "total_pages": 10,
};
