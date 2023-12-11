class ArtikelBeritaData {
  String? link;
  String? image;
  String? description;
  String? title;
  List<ArtikelBeritaPost>? posts;

  ArtikelBeritaData({
    this.link,
    this.image,
    this.description,
    this.title,
    this.posts,
  });

  factory ArtikelBeritaData.fromJson(Map<String, dynamic> json) {
    return ArtikelBeritaData(
      link: json['link'],
      image: json['image'],
      description: json['description'],
      title: json['title'],
      posts: (json['posts'] as List<dynamic>?)
          ?.map((post) => ArtikelBeritaPost.fromJson(post))
          .toList(),
    );
  }
}

class ArtikelBeritaPost {
  String? link;
  String? title;
  String? pubDate;
  String? description;
  String? thumbnail;

  ArtikelBeritaPost({
    this.link,
    this.title,
    this.pubDate,
    this.description,
    this.thumbnail,
  });

  factory ArtikelBeritaPost.fromJson(Map<String, dynamic> json) {
    return ArtikelBeritaPost(
      link: json['link'],
      title: json['title'],
      pubDate: json['pubDate'],
      description: json['description'],
      thumbnail: json['thumbnail'],
    );
  }
}
