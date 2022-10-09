import 'package:flutter/foundation.dart';

import 'enum_form_field.dart';

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

class CaseTypeFormField extends EnumFormField<CaseType> {
  final CaseType caseType;
  CaseTypeFormField({required this.caseType});

  @override
  String toUiString() {
    return caseType.toUiString();
  }

  @override
  get value => caseType;
}

final Iterable<CaseTypeFormField> caseTypeFormFieldValues =
    caseTypeValues.map((e) => CaseTypeFormField(caseType: e));
