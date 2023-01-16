enum CollectionStatus { unknown, own, ordered, trade, owned }

final collectionStatusFieldValues = <CollectionStatus, String>{
  CollectionStatus.unknown: 'Unknown',
  CollectionStatus.ordered: 'Ordered',
  CollectionStatus.own: 'Own',
  CollectionStatus.owned: 'Owned previously',
  CollectionStatus.trade: 'Trade'
};
