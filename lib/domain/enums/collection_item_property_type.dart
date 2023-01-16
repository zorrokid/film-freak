// TODO: should these be common with release?
enum CollectionItemPropertyType {
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

final collectionItemPropertyFieldValues = <CollectionItemPropertyType, String>{
  CollectionItemPropertyType.slipCover: 'Slip cover',
  CollectionItemPropertyType.hologramCover: 'Hologram cover',
  CollectionItemPropertyType.rental: 'Rental',
  CollectionItemPropertyType.doubleSidedCoverWithScenes:
      'Double sided cover (with scene list)',
  CollectionItemPropertyType.doubleSidedCoverWithInfo:
      'Double sided cover (with movie info)',
  CollectionItemPropertyType.doubleSidedCoverWithAd:
      'Double sided cover (with advertisenment)',
  CollectionItemPropertyType.hasLeafletWithScenes:
      'Has leaflet (with scene list)',
  CollectionItemPropertyType.hasLeafletWithInfo:
      'Has leaflet (with movie info)',
  CollectionItemPropertyType.hasLeafletWIthAd:
      'Has leaflet (with advertisenment)',
  CollectionItemPropertyType.hasPoster: 'Has poster',
};
