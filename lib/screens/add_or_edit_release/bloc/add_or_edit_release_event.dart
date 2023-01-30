import 'package:equatable/equatable.dart';
import 'package:film_freak/domain/enums/case_type.dart';
import 'package:film_freak/domain/enums/picture_type.dart';
import 'package:flutter/widgets.dart';

import '../../../domain/entities/release.dart';
import '../../../domain/enums/media_type.dart';

// inspiration: https://bloclibrary.dev/#/flutterlogintutorial
abstract class AddOrEditReleaseEvent extends Equatable {
  const AddOrEditReleaseEvent();

  @override
  List<Object> get props => [];
}

class CaseTypeChanged extends AddOrEditReleaseEvent {
  const CaseTypeChanged(this.caseType);

  final CaseType? caseType;

  @override
  List<Object> get props => [caseType ?? CaseType.unknown];
}

class LoadRelease extends AddOrEditReleaseEvent {
  const LoadRelease(this.releaseId);

  final int releaseId;

  @override
  List<Object> get props => [releaseId];
}

class InitRelease extends AddOrEditReleaseEvent {
  const InitRelease(this.barcode);

  final String barcode;

  @override
  List<Object> get props => [barcode];
}

class ChangePicType extends AddOrEditReleaseEvent {
  const ChangePicType(this.pictureType);
  final PictureType pictureType;

  @override
  List<Object> get props => [pictureType];
}

class ScanBarcode extends AddOrEditReleaseEvent {
  const ScanBarcode(this.context);

  final BuildContext context;

  @override
  List<Object> get props => [context];
}

class GetImageText extends AddOrEditReleaseEvent {
  const GetImageText(this.context, this.controller, this.capitalizeWords);
  final BuildContext context;
  final bool capitalizeWords;
  final TextEditingController controller;

  @override
  List<Object> get props => [context, controller, capitalizeWords];
}

class InitState extends AddOrEditReleaseEvent {
  const InitState(this.saveDir, this.id, this.barcode);
  final String saveDir;
  final int? id;
  final String? barcode;

  @override
  List<Object> get props => [saveDir, id ?? 0, barcode ?? ''];
}

class SetNextPic extends AddOrEditReleaseEvent {
  const SetNextPic();
}

class SetPrevPic extends AddOrEditReleaseEvent {
  const SetPrevPic();
}

class Submit extends AddOrEditReleaseEvent {
  const Submit(this.context, this.name, this.barcode);
  final BuildContext context;
  final String name;
  final String barcode;
  @override
  List<Object> get props => [context, name, barcode];
}

class DeletePics extends AddOrEditReleaseEvent {
  const DeletePics();
}

class CropPic extends AddOrEditReleaseEvent {
  const CropPic(this.context);
  final BuildContext context;
  @override
  List<Object> get props => [context];
}

class SelectProperties extends AddOrEditReleaseEvent {
  const SelectProperties(this.context);
  final BuildContext context;
  @override
  List<Object> get props => [context];
}

class SearchProduction extends AddOrEditReleaseEvent {
  const SearchProduction(this.context, this.searchText);
  final BuildContext context;
  final String searchText;
  @override
  List<Object> get props => [context, searchText];
}

class RemoveProduction extends AddOrEditReleaseEvent {
  const RemoveProduction(this.tmdbId);
  final int tmdbId;
  @override
  List<Object> get props => [tmdbId];
}

class SelectPic extends AddOrEditReleaseEvent {
  const SelectPic(this.fileName);
  final String fileName;
  @override
  List<Object> get props => [fileName];
}

class RemovePic extends AddOrEditReleaseEvent {
  const RemovePic();
}

class SelectMedia extends AddOrEditReleaseEvent {
  const SelectMedia(this.context);
  final BuildContext context;
  @override
  List<Object> get props => [context];
}

class AddMedia extends AddOrEditReleaseEvent {
  const AddMedia(this.pcs, this.mediaType);
  final int pcs;
  final MediaType mediaType;
  @override
  List<Object> get props => [pcs, mediaType];
}
