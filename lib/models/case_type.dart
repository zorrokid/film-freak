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

final Map<CaseType, String> caseTypeFormFieldValues = {
  CaseType.unknown: "Unknown",
  CaseType.regularDvd: "DVD (regular)",
  CaseType.regularBluRay: "Blu-ray (regular)",
  CaseType.slimDvd: "DVD (slim)",
  CaseType.slimBluRay: "Blu-ray (slim)",
  CaseType.digipack: "Digipack",
  CaseType.mediabook: "Mediabook",
  CaseType.steelbook: "Steelbook",
  CaseType.tincase: "Tin case",
  CaseType.boxSetPlastic: "Plastic case",
  CaseType.boxSetCardboard: "Cardboard case",
  CaseType.specialCase: "Special case",
};
