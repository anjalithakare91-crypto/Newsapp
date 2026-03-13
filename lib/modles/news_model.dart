class NewsArticle {
  final String title;
  final String description;
  final String image;
  final String category;
  final String time;

  NewsArticle({
    required this.title,
    required this.description,
    required this.image,
    required this.category,
    required this.time,
  });

  factory NewsArticle.fromJson(Map<String, dynamic> json) {
    return NewsArticle(
      title: json["title"] ?? "",
      description: json["description"] ?? "",
      image: json["image_url"] ?? "",
      category: (json["category"] != null && json["category"].isNotEmpty)
          ? json["category"][0]
          : "General",
      time: json["pubDate"] ?? "",
    );
  }
}