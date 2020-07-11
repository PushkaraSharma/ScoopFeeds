class News {
  final String heading;
  final String summary;
  final String picUrl;

  News._({this.heading, this.summary,this.picUrl});

  factory News.fromJson(Map<String, dynamic> json) {
    return News._(
      heading: json['heading'],
      summary: json['summary'],
      picUrl: json['picture'],
    );
  }
}