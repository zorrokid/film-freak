import '../../enums/case_type.dart';
import '../../enums/condition.dart';
import '../../enums/media_type.dart';
import 'list_model_base.dart';

class CollectionItemListModel extends ListModelBase {
  Condition condition;
  CollectionItemListModel({
    required int id,
    required String name,
    required MediaType mediaType,
    required String barcode,
    required CaseType caseType,
    required this.condition,
    String? movieName,
    String? picFileName,
  }) : super(
          barcode: barcode,
          caseType: caseType,
          id: id,
          mediaType: mediaType,
          name: name,
          movieName: movieName,
          picFileName: picFileName,
        );
}
