import 'package:animestar/Models/Episode.dart';

class AnimeDetail {
  final String description, status, season, otherName;
  final List<String> genres;
  final List<Episode> episodes;
  AnimeDetail(
      {this.description,
      this.otherName,
      this.episodes,
      this.genres,
      this.season,
      this.status});

  factory AnimeDetail.fromDynamic(dynamic data) => AnimeDetail(
      description: data['description'],
      episodes: List.from(data['episodeList'])
          .map((each) => Episode.fromDynamic(each))
          .toList(),
      genres: List.from(data['genreList']).map((e) => e.toString()).toList(),
      otherName: data['otherName'],
      season: data['season'],
      status: data['status']);
}
