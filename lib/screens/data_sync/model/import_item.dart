class ImportItem {
  ImportItem({
    required this.externalId,
    required this.barcode,
    required this.originalName,
    required this.localName,
    required this.mediaType,
    required this.releaseCountry,
    required this.releaseId,
  });

  final String externalId;
  final String barcode;
  final String originalName;
  final String localName;
  final String mediaType;
  final String releaseCountry;
  final String releaseId;
}
