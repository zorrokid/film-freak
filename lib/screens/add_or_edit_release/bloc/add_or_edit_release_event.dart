import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/enums/case_type.dart';
import '../../../domain/enums/picture_type.dart';

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
  const GetImageText(
    this.context,
    this.controller,
    this.capitalizeWords,
    this.saveDir,
  );
  final BuildContext context;
  final bool capitalizeWords;
  final TextEditingController controller;
  final Directory saveDir;

  @override
  List<Object> get props => [
        context,
        controller,
        capitalizeWords,
        saveDir,
      ];
}

class InitState extends AddOrEditReleaseEvent {
  const InitState(this.id, this.barcode);
  final int? id;
  final String? barcode;

  @override
  List<Object> get props => [id ?? 0, barcode ?? ''];
}

class Submit extends AddOrEditReleaseEvent {
  const Submit(
    this.context,
    this.name,
    this.barcode,
    this.notes,
  );
  final BuildContext context;
  final String name;
  final String barcode;
  final String notes;
  @override
  List<Object> get props => [
        context,
        name,
        barcode,
        notes,
      ];
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
  const SelectPic();
  @override
  List<Object> get props => [];
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

class SetSelectedPicIndex extends AddOrEditReleaseEvent {
  const SetSelectedPicIndex(this.selectedPicIndex);
  final int selectedPicIndex;
  @override
  List<Object> get props => [selectedPicIndex];
}
