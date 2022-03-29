import 'package:cloud_firestore/cloud_firestore.dart';

class Anime {
  final String title, image, released, link;

  Anime({this.title, this.image, this.link, this.released});

  Map<String, dynamic> toMap() =>
      {"title": title, "image": image, "link": link, "released": released};

  factory Anime.fromDynamic(dynamic data) => Anime(
      image: data['image'],
      link: data['link'],
      released:
          data['released'] == null ? data['latestEpisode'] : data['released'],
      title: data['title']);

  factory Anime.fromMap(Map<String, dynamic> data) => Anime(
      image: data['image'],
      link: data['link'],
      released:
          data['released'] == null ? data['latestEpisode'] : data['released'],
      title: data['title']);

  factory Anime.fromDocumentSnapshot(DocumentSnapshot data) => Anime(
      image: data['image'],
      link: data['link'],
      released:
          data['released'] == null ? data['latestEpisode'] : data['released'],
      title: data['title']);
}
