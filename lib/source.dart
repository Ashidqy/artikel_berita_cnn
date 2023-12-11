class NewsSourceResponse {
  String status;
  List<NewsSource> sources;

  NewsSourceResponse({
    required this.status,
    required this.sources,
  });

  factory NewsSourceResponse.fromJson(Map<String, dynamic> json) {
    List<NewsSource> sourceList = (json['sources'] as List)
        .map((sourceJson) => NewsSource.fromJson(sourceJson))
        .toList();

    return NewsSourceResponse(
      status: json['status'],
      sources: sourceList,
    );
  }
}

class NewsSource {
  String id;
  String name;
  String description;
  String url;
  String category;
  String language;
  String country;

  NewsSource({
    required this.id,
    required this.name,
    required this.description,
    required this.url,
    required this.category,
    required this.language,
    required this.country,
  });

  factory NewsSource.fromJson(Map<String, dynamic> json) {
    return NewsSource(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      url: json['url'],
      category: json['category'],
      language: json['language'],
      country: json['country'],
    );
  }
}
