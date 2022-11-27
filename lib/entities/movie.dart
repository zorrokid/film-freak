import 'entity.dart';

class Movie extends Entity<Movie> {
  int? tmdbId;
  String title;
  String originalTitle;
  String? overView;
  DateTime? releaseDate;

  Movie({
    int? id,
    DateTime? createdTime,
    DateTime? modifiedTime,
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
    return Movie(
      id: map['id'] as int,
      createdTime: DateTime.parse(map['createdTime'] as String),
      modifiedTime: DateTime.parse(map['modifiedTime'] as String),
      tmdbId: map['tmdbId'] as int,
      title: map['title'] as String,
      originalTitle: map['originalTitle'] as String,
      overView: map['overView'] as String,
    );
  }
}
