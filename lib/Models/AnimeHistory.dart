import 'package:cloud_firestore/cloud_firestore.dart';

class AnimeHistory {
  final String title, image, released, link, episodeTitle, episodeLink;
  AnimeHistory(
      {this.title,
      this.image,
      this.link,
      this.released,
      this.episodeLink,
      this.episodeTitle});

  Map<String, dynamic> toMap() => {
        "title": title,
        "image": image,
        "link": link,
        "released": released,
        "episodeLink": episodeLink,
        "episodeTitle": episodeTitle
      };

  factory AnimeHistory.fromMap(Map<String, dynamic> data) => AnimeHistory(
      image: data['image'],
      link: data['link'],
      released: data['released'],
      title: data['title'],
      episodeLink: data['episodeLink'],
      episodeTitle: data['episodeTitle']);

  factory AnimeHistory.fromDocumentSnapshot(DocumentSnapshot data) =>
      AnimeHistory(
          image: data['image'],
          link: data['link'],
          released: data['released'],
          title: data['title'],
          episodeLink: data['episodeLink'],
          episodeTitle: data['episodeTitle']);
}
