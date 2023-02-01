import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import '../../../domain/enums/collection_status.dart';
import '../../../domain/enums/condition.dart';

abstract class AddOrEditCollectionItemEvent extends Equatable {
  const AddOrEditCollectionItemEvent();
  @override
  List<Object?> get props => [];
}

class InitState extends AddOrEditCollectionItemEvent {
  const InitState(this.releaseId, this.collectionItemId);
  final int? collectionItemId;
  final int releaseId;
  @override
  List<Object?> get props => [collectionItemId ?? 0, releaseId];
}

class LoadCollectionItem extends AddOrEditCollectionItemEvent {
  const LoadCollectionItem(this.collectionItemId);
  final int collectionItemId;
  @override
  List<Object?> get props => [collectionItemId];
}

class InitCollectionItem extends AddOrEditCollectionItemEvent {
  const InitCollectionItem(this.releaseId);
  final int releaseId;
  @override
  List<Object?> get props => [releaseId];
}

class UpdateCollectionItemMedia extends AddOrEditCollectionItemEvent {
  const UpdateCollectionItemMedia(this.index, this.condition);
  final int index;
  final Condition condition;
  @override
  List<Object?> get props => [index, condition];
}

class Submit extends AddOrEditCollectionItemEvent {
  const Submit(this.context);
  final BuildContext context;
  @override
  List<Object?> get props => [];
}

class SelectStatus extends AddOrEditCollectionItemEvent {
  const SelectStatus(this.status);
  final CollectionStatus? status;
  @override
  List<Object?> get props => [status ?? CollectionStatus.unknown];
}

class SelectCondition extends AddOrEditCollectionItemEvent {
  const SelectCondition(this.condition);
  final Condition? condition;
  @override
  List<Object?> get props => [condition ?? Condition.unknown];
}
