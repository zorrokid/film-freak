import '../../domain/enums/case_type.dart';
import '../../domain/enums/media_type.dart';

class ListModelBase {
  int id;
  String name;
  List<MediaType> mediaTypes;
  String barcode;
  CaseType caseType;
  List<String> productionNames;
  String? picFileName;

  ListModelBase({
    required this.id,
    required this.name,
    required this.mediaTypes,
    required this.barcode,
    required this.caseType,
    required this.productionNames,
    this.picFileName,
  });
}
