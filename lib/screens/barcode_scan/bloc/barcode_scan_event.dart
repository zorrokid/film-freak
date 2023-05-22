import 'package:equatable/equatable.dart';
import 'package:film_freak/persistence/query_specs/query_specs_enums.dart';
import 'package:flutter/widgets.dart';

import '../../../persistence/query_specs/release_query_specs.dart';

abstract class BarcodeScanEvent extends Equatable {
  const BarcodeScanEvent();
  @override
  List<Object> get props => [];
}

class Initialize extends BarcodeScanEvent {
  const Initialize({
    this.querySpecs =
        const ReleaseQuerySpecs(top: 10, orderBy: OrderByEnum.latest),
  });
  final ReleaseQuerySpecs querySpecs;
  @override
  List<Object> get props => [querySpecs];
}

class ScanBarcode extends BarcodeScanEvent {
  const ScanBarcode(this.context);
  final BuildContext context;
  @override
  List<Object> get props => [context];
}

class GetReleases extends BarcodeScanEvent {
  const GetReleases(this.querySpecs);
  final ReleaseQuerySpecs querySpecs;
  @override
  List<Object> get props => [querySpecs];
}

class AddRelease extends BarcodeScanEvent {
  const AddRelease(
    this.context,
    this.barcode,
  );
  final BuildContext context;
  final String barcode;
  @override
  List<Object> get props => [context, barcode];
}

class CreateCollectionItem extends BarcodeScanEvent {
  const CreateCollectionItem(
    this.context,
    this.releaseId,
  );
  final BuildContext context;
  final int releaseId;
  @override
  List<Object> get props => [context, releaseId];
}

class ConfirmDelete extends BarcodeScanEvent {
  const ConfirmDelete(
    this.context,
    this.releaseId,
  );
  final BuildContext context;
  final int releaseId;
  @override
  List<Object> get props => [context, releaseId];
}

class DeleteRelease extends BarcodeScanEvent {
  const DeleteRelease(
    this.releaseId,
  );
  final int releaseId;
  @override
  List<Object> get props => [releaseId];
}

class EditRelease extends BarcodeScanEvent {
  const EditRelease(
    this.context,
    this.releaseId,
  );
  final BuildContext context;
  final int releaseId;
  @override
  List<Object> get props => [context, releaseId];
}

class ViewRelease extends BarcodeScanEvent {
  const ViewRelease(
    this.context,
    this.releaseId,
  );
  final BuildContext context;
  final int releaseId;
  @override
  List<Object> get props => [context, releaseId];
}
