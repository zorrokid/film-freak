enum OrderByEnum {
  latest,
  oldest,
}

class CollectionItemQuerySpecs {
  final String? barcode;
  final int? top;
  final OrderByEnum? orderBy;

  const CollectionItemQuerySpecs({this.barcode, this.top, this.orderBy});
}
