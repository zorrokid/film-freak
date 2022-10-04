import 'package:flutter/foundation.dart';

enum MediaType { vhs, dvd, bluRay }

extension MediaTypeExtension on MediaType {
  String toUiString() {
    return describeEnum(this).toUpperCase();
  }
}

const mediaTypeValues = [MediaType.bluRay, MediaType.dvd, MediaType.vhs];

enum CaseType {
  unknown,
  regularDvd,
  slimDvd,
  regularBluRay,
  slimBluRay,
  mediabook,
  digipack,
  boxSetPlastic,
  boxSetCardboard,
  specialCase,
  steelbook,
  tincase
}

extension CaseTypeExtension on CaseType {
  String toUiString() {
    // TODO: maybe get values from translation resource
    return describeEnum(this);
  }
}

const caseTypeValues = [
  CaseType.unknown,
  CaseType.regularDvd,
  CaseType.slimDvd,
  CaseType.regularBluRay,
  CaseType.slimBluRay,
  CaseType.mediabook,
  CaseType.digipack,
  CaseType.boxSetPlastic,
  CaseType.boxSetCardboard,
  CaseType.specialCase,
  CaseType.steelbook,
  CaseType.tincase
];
