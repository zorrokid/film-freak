import 'package:equatable/equatable.dart';

import '../../../models/release_view_model.dart';

enum ReleaseViewStatus {
  initial,
  loading,
  loaded,
  loadFailed,
}

class ReleaseViewState extends Equatable {
  const ReleaseViewState._({
    this.releaseId = 0,
    this.status = ReleaseViewStatus.initial,
    this.error = "",
    this.release,
  });
  const ReleaseViewState.initial() : this._();
  const ReleaseViewState.loading(int releaseId) : this._(releaseId: releaseId);
  const ReleaseViewState.loaded(ReleaseViewModel release)
      : this._(release: release, status: ReleaseViewStatus.loaded);
  const ReleaseViewState.loadFailed(String error)
      : this._(status: ReleaseViewStatus.loadFailed, error: error);

  final int releaseId;
  final ReleaseViewStatus status;
  final ReleaseViewModel? release;
  final String error;

  @override
  List<Object?> get props => [status, releaseId, release, error];
}
