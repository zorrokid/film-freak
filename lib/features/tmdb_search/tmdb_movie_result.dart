class TmdbMovieResult {
  TmdbMovieResult(
      {required this.id,
      required this.title,
      required this.originalTitle,
      required this.overview,
      required this.releaseDate,
      required this.isAdult,
      required this.posterPath});
  int id;
  String title;
  String originalTitle;
  String overview;
  String releaseDate;
  bool isAdult;
  String posterPath;

  static TmdbMovieResult fromJson(Map<String, Object?> json) {
    return TmdbMovieResult(
        id: json['id'] != null ? json['id'] as int : 0,
        title: json['title'] != null ? json['title'] as String : '',
        originalTitle: json['original_title'] as String,
        overview: json['overview'] != null ? json['overview'] as String : '',
        releaseDate:
            json['release_date'] != null ? json['release_date'] as String : '',
        isAdult: json['adult'] != null ? json['adult'] as bool : false,
        posterPath:
            json['poster_path'] != null ? json['poster_path'] as String : '');
  }
}
