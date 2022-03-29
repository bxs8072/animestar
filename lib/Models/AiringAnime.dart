import 'package:cloud_firestore/cloud_firestore.dart';

class AiringAnime {
  final int id, malId, episode, duration;
  final Timestamp airingAt;
  final String startDate,
      status,
      season,
      title,
      nativetitle,
      countryOfOrigin,
      description,
      coverImage;

  final List<String> synonyms;

  AiringAnime(
      {this.id,
      this.duration,
      this.title,
      this.nativetitle,
      this.malId,
      this.episode,
      this.airingAt,
      this.startDate,
      this.status,
      this.season,
      this.countryOfOrigin,
      this.description,
      this.coverImage,
      this.synonyms});

  factory AiringAnime.fromDynamic(dynamic data) => AiringAnime(
        airingAt: Timestamp.fromMillisecondsSinceEpoch(data['airingAt'] * 1000),
        countryOfOrigin: data['countryOfOrigin'],
        coverImage: data['coverImage'],
        description: data['description'],
        episode: data['episode'],
        id: data['id'],
        nativetitle: data['nativetitle'],
        title: data['title'],
        duration: data['duration'],
        malId: data['malId'],
        season: data['season'],
        startDate: data['startDate'],
        status: data['status'],
        synonyms: List.from(data['synonyms']).map((e) => e.toString()).toList(),
      );
}
