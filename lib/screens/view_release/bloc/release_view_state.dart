import 'package:equatable/equatable.dart';

import '../../../models/release_view_model.dart';

enum ReleaseViewStatus {
  initial,
  loading,
  loaded,
  loadFailed,
  edited,
  collectionItemEdited,
  collectionItemDeleted,
}

class ReleaseViewState extends Equatable {
  const ReleaseViewState({
    this.releaseId = 0,
    this.status = ReleaseViewStatus.initial,
    this.error = "",
    this.release,
  });

  final int releaseId;
  final ReleaseViewStatus status;
  final ReleaseViewModel? release;
  final String error;

  ReleaseViewState copyWith({
    int? releaseId,
    ReleaseViewStatus? status,
    ReleaseViewModel? release,
    String? error,
  }) {
    return ReleaseViewState(
      release: release ?? this.release,
      error: error ?? this.error,
      releaseId: releaseId ?? this.releaseId,
      status: status ?? this.status,
    );
  }

  @override
  List<Object?> get props => [status, releaseId, release, error];
}
