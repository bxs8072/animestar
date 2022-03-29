class Episode {
  final String link, title;
  Episode({this.link, this.title});

  Map<String, dynamic> get toMap => {"link": link, "title": title};

  factory Episode.fromDynamic(dynamic data) =>
      Episode(link: data['link'], title: data['title']);
}
