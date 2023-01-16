import 'entity.dart';

class ReleaseProduction extends ReleaseChildEntity<ReleaseProduction> {
  final int productionId;
  ReleaseProduction({
    int? id,
    required int releaseId,
    required this.productionId,
    DateTime? createdTime,
    DateTime? modifiedTime,
  }) : super(
          id: id,
          releaseId: releaseId,
          createdTime: createdTime,
          modifiedTime: modifiedTime,
        );

  @override
  Map<String, dynamic> get map => {
        'id': id,
        'releaseId': releaseId,
        'productionId': productionId,
        'createdTime': (createdTime ?? DateTime.now()).toIso8601String(),
        'modifiedTime': (modifiedTime ?? DateTime.now()).toIso8601String(),
      };

  static ReleaseProduction fromMap(Map<String, dynamic> map) {
    return ReleaseProduction(
      id: map['id'] as int,
      releaseId: map['releaseId'] as int,
      productionId: map['productionId'] as int,
      createdTime: DateTime.parse(map['createdTime'] as String),
      modifiedTime: DateTime.parse(map['modifiedTime'] as String),
    );
  }
}
