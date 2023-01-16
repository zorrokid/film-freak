import 'list_model_base.dart';
import '../../domain/enums/case_type.dart';
import '../../domain/enums/condition.dart';
import '../../domain/enums/media_type.dart';

class CollectionItemListModel extends ListModelBase {
  Condition condition;
  CollectionItemListModel({
    required int id,
    required String name,
    required List<MediaType> mediaTypes,
    required String barcode,
    required CaseType caseType,
    required this.condition,
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
