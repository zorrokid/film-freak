import 'package:equatable/equatable.dart';
import 'package:film_freak/persistence/query_specs/query_specs_enums.dart';
import 'package:flutter/widgets.dart';

import '../../../persistence/query_specs/release_query_specs.dart';

abstract class ReleasesEvent extends Equatable {
  const ReleasesEvent();
  @override
  List<Object> get props => [];
}

class Initialize extends ReleasesEvent {
  const Initialize({
    this.querySpecs =
        const ReleaseQuerySpecs(top: 10, orderBy: OrderByEnum.latest),
  });
  final ReleaseQuerySpecs querySpecs;
  @override
  List<Object> get props => [querySpecs];
}

class ScanBarcode extends ReleasesEvent {
  const ScanBarcode(this.context);
  final BuildContext context;
  @override
  List<Object> get props => [context];
}

class GetReleases extends ReleasesEvent {
  const GetReleases(this.querySpecs);
  final ReleaseQuerySpecs querySpecs;
  @override
  List<Object> get props => [querySpecs];
}

class AddRelease extends ReleasesEvent {
  const AddRelease(
    this.context,
    this.barcode,
  );
  final BuildContext context;
  final String barcode;
  @override
  List<Object> get props => [context, barcode];
}

class CreateCollectionItem extends ReleasesEvent {
  const CreateCollectionItem(
    this.context,
    this.releaseId,
  );
  final BuildContext context;
  final int releaseId;
  @override
  List<Object> get props => [context, releaseId];
}

class ConfirmDelete extends ReleasesEvent {
  const ConfirmDelete(
    this.context,
    this.releaseId,
  );
  final BuildContext context;
  final int releaseId;
  @override
  List<Object> get props => [context, releaseId];
}

class DeleteRelease extends ReleasesEvent {
  const DeleteRelease(
    this.releaseId,
  );
  final int releaseId;
  @override
  List<Object> get props => [releaseId];
}

class EditRelease extends ReleasesEvent {
  const EditRelease(
    this.context,
    this.releaseId,
  );
  final BuildContext context;
  final int releaseId;
  @override
  List<Object> get props => [context, releaseId];
}

class ViewRelease extends ReleasesEvent {
  const ViewRelease(
    this.context,
    this.releaseId,
  );
  final BuildContext context;
  final int releaseId;
  @override
  List<Object> get props => [context, releaseId];
}

class ReloadRelease extends ReleasesEvent {
  const ReloadRelease(
    this.releaseId,
  );
  final int releaseId;
  @override
  List<Object> get props => [releaseId];
}
