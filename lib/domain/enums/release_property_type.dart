enum ReleasePropertyType {
  slipCover,
  hologramCover,
  rental,
  doubleSidedCoverWithScenes,
  doubleSidedCoverWithInfo,
  doubleSidedCoverWithAd,
  hasLeafletWithScenes,
  hasLeafletWithInfo,
  hasLeafletWIthAd,
  hasPoster,
}

final releasePropertyFieldValues = <ReleasePropertyType, String>{
  ReleasePropertyType.slipCover: 'Slip cover',
  ReleasePropertyType.hologramCover: 'Hologram cover',
  ReleasePropertyType.rental: 'Rental',
  ReleasePropertyType.doubleSidedCoverWithScenes:
      'Double sided cover (with scene list)',
  ReleasePropertyType.doubleSidedCoverWithInfo:
      'Double sided cover (with movie info)',
  ReleasePropertyType.doubleSidedCoverWithAd:
      'Double sided cover (with advertisenment)',
  ReleasePropertyType.hasLeafletWithScenes: 'Has leaflet (with scene list)',
  ReleasePropertyType.hasLeafletWithInfo: 'Has leaflet (with movie info)',
  ReleasePropertyType.hasLeafletWIthAd: 'Has leaflet (with advertisenment)',
  ReleasePropertyType.hasPoster: 'Has poster',
};
