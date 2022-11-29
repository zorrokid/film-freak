import '../enums/case_type.dart';
import '../enums/condition.dart';
import '../enums/media_type.dart';

class CollectionItemListModel {
  int id;
  String name;
  MediaType mediaType;
  String barcode;
  CaseType caseType;
  Condition condition;
  String? movieName;
  String? picFileName;

  CollectionItemListModel({
    required this.id,
    required this.name,
    required this.mediaType,
    required this.barcode,
    required this.caseType,
    required this.condition,
    this.movieName,
    this.picFileName,
  });
}
