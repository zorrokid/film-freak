import 'package:tuple/tuple.dart';

import '../../models/collection_item_query_specs.dart';

class QueryHelper {
  static String? getOrderBy(CollectionItemQuerySpecs? filter) {
    if (filter == null || filter.orderBy == null) return null;
    final orderByClauses = <String>[];
    if (filter.orderBy == OrderByEnum.latest) {
      orderByClauses.add('modifiedTime DESC');
    }
    if (filter.orderBy == OrderByEnum.oldest) {
      orderByClauses.add('modifiedTime ASC');
    }
    return orderByClauses.join(', ');
  }

  static Tuple2<String?, List<Object?>?> filterToQueryArgs(
      CollectionItemQuerySpecs? filter) {
    if (filter == null) return const Tuple2(null, null);

    final whereArgs = <Object?>[];
    final whereConditions = <String>[];

    if (filter.barcode != null) {
      whereConditions.add('barcode = ?');
      whereArgs.add(filter.barcode!);
    }

    if (whereConditions.isEmpty) {
      return const Tuple2(null, null);
    }

    final where = whereConditions.join(' AND ');
    return Tuple2(where, whereArgs);
  }
}
