import 'package:equatable/equatable.dart';

import '../../../domain/enums/media_type.dart';
import '../../../domain/entities/production.dart';
import '../../../domain/entities/release_media.dart';
import '../../../domain/entities/release_picture.dart';
import '../../../domain/entities/release_property.dart';
import '../../../domain/enums/case_type.dart';
import '../../../models/release_view_model.dart';

enum AddOrEditReleaseStatus {
  initial,
  initialized,
  loading,
  loaded,
  add,
  editStart,
  editDone,
  picturesUpdated,
  scanned,
  imageTextSelected,
  submitting,
  submitted,
  picsDeleted,
  imageCropped,
  propertiesSelected,
  productionSelected,
  productionRemoved,
  picAdded,
  picRemoved,
  mediaAdded,
}

class AddOrEditReleaseState extends Equatable {
  const AddOrEditReleaseState({
    this.id,
    this.barcode = "",
    this.viewModel,
    this.caseType = CaseType.unknown,
    this.media = const <ReleaseMedia>[],
    this.pictures = const <ReleasePicture>[],
    this.picturesToDelete = const <ReleasePicture>[],
    this.productions = const <Production>[],
    this.properties = const <ReleaseProperty>[],
    this.selectedPicIndex = 0,
    this.status = AddOrEditReleaseStatus.initial,
    this.errors = const <String>[],
    this.selectedImageText = "",
    this.addedMediaPcs = 0,
    this.addedMediaType = MediaType.unknown,
  });

  final AddOrEditReleaseStatus? status;
  final int? id;
  final String barcode;
  final ReleaseViewModel? viewModel;
  final CaseType caseType;
  final List<ReleasePicture> pictures;
  final List<ReleasePicture> picturesToDelete;
  final List<Production> productions;
  final List<ReleaseProperty> properties;
  final List<ReleaseMedia> media;
  final int selectedPicIndex;
  final List<String> errors;
  final String selectedImageText;
  final MediaType addedMediaType;
  final int addedMediaPcs;

  AddOrEditReleaseState copyWith({
    AddOrEditReleaseStatus? status,
    int? id,
    String? barcode,
    ReleaseViewModel? viewModel,
    CaseType? caseType,
    List<ReleasePicture>? pictures,
    List<ReleasePicture>? picturesToDelete,
    List<Production>? productions,
    List<ReleaseProperty>? properties,
    List<ReleaseMedia>? media,
    int? selectedPicIndex,
    List<String>? errors,
    String? selectedImageText,
    int? addedMediaPcs,
    MediaType? addedMediaType,
  }) {
    return AddOrEditReleaseState(
      status: status ?? this.status,
      id: id ?? this.id,
      barcode: barcode ?? this.barcode,
      viewModel: viewModel ?? this.viewModel,
      caseType: caseType ?? this.caseType,
      pictures: pictures ?? this.pictures,
      picturesToDelete: picturesToDelete ?? this.picturesToDelete,
      productions: productions ?? this.productions,
      properties: properties ?? this.properties,
      media: media ?? this.media,
      selectedPicIndex: selectedPicIndex ?? this.selectedPicIndex,
      errors: errors ?? this.errors,
      selectedImageText: selectedImageText ?? this.selectedImageText,
      addedMediaPcs: addedMediaPcs ?? this.addedMediaPcs,
      addedMediaType: addedMediaType ?? this.addedMediaType,
    );
  }

  @override
  List<Object?> get props => [
        status,
        id,
        barcode,
        viewModel,
        caseType,
        pictures,
        properties,
        media,
        selectedPicIndex,
        errors,
        selectedImageText,
        addedMediaPcs,
        addedMediaType,
      ];
}
