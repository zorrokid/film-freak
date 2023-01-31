import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';

abstract class ReleaseViewEvent extends Equatable {
  const ReleaseViewEvent();
  @override
  List<Object> get props => [];
}

class LoadRelease extends ReleaseViewEvent {
  const LoadRelease(this.releaseId);
  final int releaseId;
  @override
  List<Object> get props => [releaseId];
}

class EditRelease extends ReleaseViewEvent {
  const EditRelease(this.context, this.releaseId);
  final BuildContext context;
  final int releaseId;
  @override
  List<Object> get props => [context, releaseId];
}
