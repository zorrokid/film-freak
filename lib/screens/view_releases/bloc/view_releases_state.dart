import 'package:equatable/equatable.dart';

import '../../../models/list_models/release_list_model.dart';
import '../../../persistence/query_specs/release_query_specs.dart';

enum ViewReleasesStatus {
  initial,
  initialized,
  loading,
  loaded,
  success,
  failure,
  releaseAdded,
  collectionItemAdded,
  deleteConfirmed,
  releaseDeleted,
  releaseEdited,
}

class ViewReleasesState extends Equatable {
  const ViewReleasesState({
    this.status = ViewReleasesStatus.initial,
    this.items = const <ReleaseListModel>[],
    this.error = "",
    this.releaseId,
    this.canDelete = false,
    this.filter,
  });

  final ViewReleasesStatus status;
  final List<ReleaseListModel> items;
  final String error;
  final int? releaseId;
  final bool canDelete;
  final ReleaseQuerySpecs? filter;

  @override
  List<Object?> get props => [
        status,
        items,
        error,
        releaseId,
        canDelete,
        filter,
      ];

  ViewReleasesState copyWith({
    ViewReleasesStatus? status,
    List<ReleaseListModel>? items,
    String? error,
    int? releaseId,
    bool? canDelete,
    ReleaseQuerySpecs? filter,
  }) {
    return ViewReleasesState(
      status: status ?? this.status,
      items: items ?? this.items,
      error: error ?? this.error,
      releaseId: releaseId ?? this.releaseId,
      canDelete: canDelete ?? this.canDelete,
      filter: filter ?? this.filter,
    );
  }
}
