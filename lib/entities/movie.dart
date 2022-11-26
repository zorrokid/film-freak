import 'entity.dart';

class Movie extends Entity<Movie> {
  int? tmdbId;
  String title;
  String originalTitle;
  String? overView;
  DateTime? releaseDate;

  Movie.full(
    int? id,
    DateTime? createdTime,
    DateTime? modifiedTime, {
    required this.title,
    required this.originalTitle,
    this.tmdbId,
    this.overView,
    this.releaseDate,
  }) : super(
          id: id,
          createdTime: createdTime,
          modifiedTime: modifiedTime,
        );

  Movie({
    required this.title,
    required this.originalTitle,
    this.tmdbId,
    this.overView,
    this.releaseDate,
  });

  @override
  Map<String, dynamic> get map => {
        'id': id,
        'tmdbId': tmdbId,
        'title': title,
        'originalTitle': originalTitle,
        'overView': overView,
        'createdTime': (createdTime ?? DateTime.now()).toIso8601String(),
        'modifiedTime': (modifiedTime ?? DateTime.now()).toIso8601String(),
      };

  static Movie fromMap(Map<String, Object?> map) {
    return Movie.full(
      map['id'] as int,
      DateTime.parse(map['createdTime'] as String),
      DateTime.parse(map['modifiedTime'] as String),
      tmdbId: map['tmdbId'] as int,
      title: map['title'] as String,
      originalTitle: map['originalTitle'] as String,
      overView: map['overView'] as String,
    );
  }
}
