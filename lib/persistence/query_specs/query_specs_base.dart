import 'query_specs_enums.dart';

abstract class QuerySpecsBase {
  final String? barcode;
  final int? top;
  final OrderByEnum? orderBy;

  const QuerySpecsBase({this.barcode, this.top, this.orderBy});
}
