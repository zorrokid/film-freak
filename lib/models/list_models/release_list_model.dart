import 'package:film_freak/models/list_models/list_model_base.dart';

import '../../enums/case_type.dart';
import '../../enums/media_type.dart';

class ReleaseListModel extends ListModelBase {
  ReleaseListModel({
    required int id,
    required String name,
    required MediaType mediaType,
    required String barcode,
    required CaseType caseType,
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
