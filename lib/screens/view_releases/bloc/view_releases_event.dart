import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

import '../../../persistence/query_specs/release_query_specs.dart';

abstract class ViewReleasesEvent extends Equatable {
  const ViewReleasesEvent();
  @override
  List<Object?> get props => [];
}

class Initialize extends ViewReleasesEvent {
  const Initialize(this.filter);
  final ReleaseQuerySpecs? filter;
  @override
  List<Object?> get props => [filter];
}

// TODO: these are similar events to BarcodeScanEvents - generalize to one
class GetReleases extends ViewReleasesEvent {
  const GetReleases();
  @override
  List<Object?> get props => [];
}

class AddRelease extends ViewReleasesEvent {
  const AddRelease(
    this.context,
  );
  final BuildContext context;
  @override
  List<Object> get props => [context];
}

class ConfirmDelete extends ViewReleasesEvent {
  const ConfirmDelete(
    this.context,
    this.releaseId,
  );
  final BuildContext context;
  final int releaseId;
  @override
  List<Object> get props => [context, releaseId];
}

class DeleteRelease extends ViewReleasesEvent {
  const DeleteRelease(
    this.context,
    this.releaseId,
  );
  final BuildContext context;
  final int releaseId;
  @override
  List<Object> get props => [context, releaseId];
}

class EditRelease extends ViewReleasesEvent {
  const EditRelease(
    this.context,
    this.releaseId,
  );
  final BuildContext context;
  final int releaseId;
  @override
  List<Object> get props => [context, releaseId];
}

class ViewRelease extends ViewReleasesEvent {
  const ViewRelease(
    this.context,
    this.releaseId,
  );
  final BuildContext context;
  final int releaseId;
  @override
  List<Object> get props => [context, releaseId];
}

class CreateCollectionItem extends ViewReleasesEvent {
  const CreateCollectionItem(
    this.context,
    this.releaseId,
  );
  final BuildContext context;
  final int releaseId;
  @override
  List<Object> get props => [context, releaseId];
}
