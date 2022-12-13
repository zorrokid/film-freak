import 'list_model_base.dart';
import '../../enums/case_type.dart';
import '../../enums/media_type.dart';

class ReleaseListModel extends ListModelBase {
  ReleaseListModel({
    required int id,
    required String name,
    required List<MediaType> mediaTypes,
    required String barcode,
    required CaseType caseType,
    required List<String> productionNames,
    String? picFileName,
  }) : super(
          barcode: barcode,
          caseType: caseType,
          id: id,
          mediaTypes: mediaTypes,
          name: name,
          productionNames: productionNames,
          picFileName: picFileName,
        );
}
