import 'entity.dart';
import '../enums/production_type.dart';

class Production extends Entity<Production> {
  ProductionType productionType;
  int? tmdbId;
  String title;
  String originalTitle;
  String? overView;
  DateTime? releaseDate;

  Production({
    int? id,
    DateTime? createdTime,
    DateTime? modifiedTime,
    required this.productionType,
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
        'productionType': productionType.index,
        'tmdbId': tmdbId,
        'title': title,
        'originalTitle': originalTitle,
        'overView': overView,
        'releaseDate': (modifiedTime ?? DateTime.now()).toIso8601String(),
        'createdTime': (createdTime ?? DateTime.now()).toIso8601String(),
        'modifiedTime': (modifiedTime ?? DateTime.now()).toIso8601String(),
      };

  static Production fromMap(Map<String, Object?> map) {
    return Production(
      id: map['id'] as int,
      productionType: ProductionType.values[map['productionType'] as int],
      releaseDate: DateTime.parse(map['releaseDate'] as String),
      createdTime: DateTime.parse(map['createdTime'] as String),
      modifiedTime: DateTime.parse(map['modifiedTime'] as String),
      tmdbId: map['tmdbId'] as int,
      title: map['title'] as String,
      originalTitle: map['originalTitle'] as String,
      overView: map['overView'] as String?,
    );
  }
}
