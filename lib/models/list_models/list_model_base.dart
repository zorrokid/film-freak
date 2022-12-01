import '../../enums/case_type.dart';
import '../../enums/media_type.dart';

class ListModelBase {
  int id;
  String name;
  MediaType mediaType;
  String barcode;
  CaseType caseType;
  String? movieName;
  String? picFileName;

  ListModelBase({
    required this.id,
    required this.name,
    required this.mediaType,
    required this.barcode,
    required this.caseType,
    this.movieName,
    this.picFileName,
  });
}
