class BookData {
  var id;
  var author;
  String title;
  var publisher;
  var year;
  var page_count;
  var language;
  var mirror_url;

  BookData({
    required this.id,
    required this.author,
    required this.title,
    required this.publisher,
    required this.year,
    required this.page_count,
    required this.language,
    required this.mirror_url,
  });

  factory BookData.fromJson(Map<dynamic, dynamic> json) {
    return BookData(
        id: json['id'],
        author: json['author'],
        title: json['title'],
        publisher: json['publisher'],
        year: json['year'],
        page_count: json['page_count'],
        language: json['language'],
        mirror_url: json['mirror_url']);
  }
}
