import 'dart:io';
import 'package:film_freak/screens/process_image/view/image_process_page.dart';
import 'package:film_freak/screens/select_text_from_image/view/select_text_from_image_page.dart';
import 'package:film_freak/utils/snackbar_buillder.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:path/path.dart' as p;

import '../../../extensions/string_extensions.dart';
import '../../../services/release_service.dart';
import '../../../domain/entities/release.dart';
import '../../../domain/entities/release_comment.dart';
import '../../../domain/entities/release_media.dart';
import '../../../domain/entities/release_picture.dart';
import '../../../domain/entities/release_property.dart';
import '../../../domain/enums/media_type.dart';
import '../../../domain/enums/picture_type.dart';
import '../../../models/release_view_model.dart';
import '../../../models/tmdb_movie_result.dart';
import '../../scan_barcode/barcode_scanner_view.dart';
import '../../select_properties/property_selection_view.dart';
import '../../tmdb_search/tmdb_movie_search_screen.dart';
import '../view/widgets/media_selector.dart';
import '../bloc/add_or_edit_release_state.dart';
import 'add_or_edit_release_event.dart';

class AddOrEditReleaseBloc
    extends Bloc<AddOrEditReleaseEvent, AddOrEditReleaseState> {
  AddOrEditReleaseBloc({required this.releaseService})
      : super(const AddOrEditReleaseState()) {
    on<CaseTypeChanged>(_onCaseTypeChanged);
    on<LoadRelease>(_onloadRelease);
    on<InitRelease>(_onInitRelease);
    on<ChangePicType>(_onChangePicType);
    on<ScanBarcode>(_onScanBarcode);
    on<GetImageText>(_onGetImageText);
    on<InitState>(_onInitState);
    on<Submit>(_onSubmit);
    on<CropPic>(_onCropPic);
    on<SelectProperties>(_onSelectProperties);
    on<SearchProduction>(_onSearchProduction);
    on<RemoveProduction>(_onRemoveProduction);
    on<SelectPic>(_onSelectPic);
    on<RemovePic>(_onRemovePic);
    on<SelectMedia>(_onSelectMedia);
    on<SetSelectedPicIndex>(_onSetSelectedPicIndex);
  }

  final ReleaseService releaseService;

  void _onInitState(
    InitState event,
    Emitter<AddOrEditReleaseState> emit,
  ) {
    emit(state.copyWith(
      status: AddOrEditReleaseStatus.initialized,
      id: event.id,
      barcode: event.barcode,
      saveDir: event.saveDir,
    ));
  }

  Future<void> _onSubmit(
    Submit event,
    Emitter<AddOrEditReleaseState> emit,
  ) async {
    final release = Release(
      id: state.id,
      name: event.name,
      barcode: event.barcode,
      caseType: state.caseType,
      notes: event.notes,
    );

    final model = ReleaseViewModel(
      release: release,
      pictures: state.pictures,
      properties: state.properties,
      productions: state.productions,
      medias: state.media,
      comments: <ReleaseComment>[],
      collectionItems: [],
    );

    ScaffoldMessenger.of(event.context).showSnackBar(
      SnackBarBuilder.buildSnackBar(state.id != null
          ? 'Updating ${model.release.name}'
          : 'Adding ${model.release.name}'),
    );

    emit(state.copyWith(status: AddOrEditReleaseStatus.submitting));

    final id = await releaseService.upsert(model);
    model.release.id = id;

    for (final picToDelete in state.picturesToDelete) {
      final imagePath = p.join(state.saveDir, picToDelete.filename);
      final imageFile = File(imagePath);
      await imageFile.delete();
    }

    emit(state.copyWith(
      status: AddOrEditReleaseStatus.submitted,
      viewModel: model,
    ));
  }

  Future<void> _onScanBarcode(
    ScanBarcode event,
    Emitter<AddOrEditReleaseState> emit,
  ) async {
    final barcode = await Navigator.push<String>(event.context,
        MaterialPageRoute<String>(builder: (context) {
      return const BarcodeScannerView();
    }));
    emit(state.copyWith(
      status: AddOrEditReleaseStatus.scanned,
      barcode: barcode,
    ));
  }

  Future<void> _onGetImageText(
    GetImageText event,
    Emitter<AddOrEditReleaseState> emit,
  ) async {
    if (state.pictures.isEmpty) return;
    if (state.selectedPicIndex > state.pictures.length - 1) return;
    final selectedPic = state.pictures[state.selectedPicIndex];
    final imagePath = p.join(state.saveDir, selectedPic.filename);
    var selectedText = await Navigator.push(event.context,
        MaterialPageRoute<String>(builder: (context) {
      return SelectTextFromImagePage(imagePath: imagePath);
    }));
    if (selectedText == null) return;
    if (event.capitalizeWords) {
      selectedText = selectedText.normalize().capitalizeEachWord();
    }
    event.controller.text = selectedText;
    emit(state.copyWith(
      status: AddOrEditReleaseStatus.imageTextSelected,
      selectedImageText: selectedText,
    ));
  }

  void _onCaseTypeChanged(
    CaseTypeChanged event,
    Emitter<AddOrEditReleaseState> emit,
  ) {
    emit(state.copyWith(
        caseType: event.caseType, status: AddOrEditReleaseStatus.editDone));
  }

  void _onInitRelease(
    InitRelease event,
    Emitter<AddOrEditReleaseState> emit,
  ) async {
    final model = releaseService.initializeModel(event.barcode);
    emit(state.copyWith(
      status: AddOrEditReleaseStatus.loaded,
      viewModel: model,
      pictures: model.pictures.toList(),
      properties: model.properties.toList(),
      barcode: model.release.barcode,
      caseType: model.release.caseType,
      id: model.release.id,
      media: model.medias.toList(),
      productions: model.productions.toList(),
    ));
  }

  Future<void> _onloadRelease(
    LoadRelease event,
    Emitter<AddOrEditReleaseState> emit,
  ) async {
    emit(state.copyWith(status: AddOrEditReleaseStatus.loading));
    final model = await releaseService.getModel(event.releaseId);
    emit(state.copyWith(
      status: AddOrEditReleaseStatus.loaded,
      viewModel: model,
      pictures: model.pictures.toList(),
      properties: model.properties.toList(),
      barcode: model.release.barcode,
      caseType: model.release.caseType,
      id: model.release.id,
      media: model.medias.toList(),
      productions: model.productions.toList(),
    ));
  }

  void _onChangePicType(
    ChangePicType event,
    Emitter<AddOrEditReleaseState> emit,
  ) {
    emit(state.copyWith(status: AddOrEditReleaseStatus.editStart));
    final pictures = <ReleasePicture>[...state.pictures];
    pictures[state.selectedPicIndex].pictureType = event.pictureType;
    emit(state.copyWith(
        status: AddOrEditReleaseStatus.editDone, pictures: pictures));
  }

  Future<void> _onCropPic(
    CropPic event,
    Emitter<AddOrEditReleaseState> emit,
  ) async {
    if (state.pictures.isEmpty) return;
    final picToCrop = state.pictures[state.selectedPicIndex];
    final imagePath = p.join(state.saveDir, picToCrop.filename);
    await Navigator.push(
      event.context,
      MaterialPageRoute(
        builder: (context) {
          return ImageProcessPage(imagePath: imagePath);
        },
      ),
    );
    emit(state.copyWith(status: AddOrEditReleaseStatus.imageCropped));
  }

  Future<void> _onSelectProperties(
    SelectProperties event,
    Emitter<AddOrEditReleaseState> emit,
  ) async {
    final List<ReleaseProperty>? selectedProperties = await Navigator.push(
      event.context,
      MaterialPageRoute<List<ReleaseProperty>>(
        builder: (context) {
          return PropertySelectionView(
            initialSelection: state.properties,
            releaseId: state.id,
          );
        },
      ),
    );

    if (selectedProperties == null) return;

    emit(state.copyWith(
      status: AddOrEditReleaseStatus.propertiesSelected,
      properties: selectedProperties,
    ));
  }

  Future<void> _onSearchProduction(
    SearchProduction event,
    Emitter<AddOrEditReleaseState> emit,
  ) async {
    if (event.searchText.isEmpty) {
      return;
    }
    final movieResult = await Navigator.push(
      event.context,
      MaterialPageRoute<TmdbMovieResult>(
        builder: (context) {
          return TmdbMovieSearchScreen(
            searchText: event.searchText,
          );
        },
      ),
    );
    if (movieResult == null) return;
    final production = movieResult.toProduction;
    emit(state.copyWith(
        status: AddOrEditReleaseStatus.productionSelected,
        productions: [...state.productions, production]));
  }

  void _onRemoveProduction(
    RemoveProduction event,
    Emitter<AddOrEditReleaseState> emit,
  ) {
    final productions = [...state.productions];
    productions.removeWhere((element) => element.tmdbId == event.tmdbId);
    emit(state.copyWith(
      status: AddOrEditReleaseStatus.productionRemoved,
      productions: productions,
    ));
  }

  void _onSelectPic(
    SelectPic event,
    Emitter<AddOrEditReleaseState> emit,
  ) {
    final newPic = ReleasePicture(
        releaseId: state.id,
        filename: event.fileName,
        pictureType: PictureType.coverFront);
    final pics = [...state.pictures, newPic];
    emit(state.copyWith(
      status: AddOrEditReleaseStatus.picAdded,
      pictures: pics,
      selectedPicIndex: pics.length - 1,
    ));
  }

  void _onRemovePic(
    RemovePic event,
    Emitter<AddOrEditReleaseState> emit,
  ) {
    if (state.pictures.isEmpty) return;
    final picToDelete = state.pictures[state.selectedPicIndex];

    final pictures = [...state.pictures];

    if (picToDelete.id != null) {
      pictures.removeWhere((element) => element.id == picToDelete.id);
    } else {
      pictures
          .removeWhere((element) => element.filename == picToDelete.filename);
    }
    final newIndex =
        state.selectedPicIndex > 0 ? state.selectedPicIndex - 1 : 0;
    emit(state.copyWith(
      status: AddOrEditReleaseStatus.picRemoved,
      pictures: pictures,
      selectedPicIndex: newIndex,
    ));
  }

  Future<void> _onSelectMedia(
    SelectMedia event,
    Emitter<AddOrEditReleaseState> emit,
  ) async {
    await showModalBottomSheet(
      context: event.context,
      builder: (BuildContext context) {
        return MediaSelector(
          onAddMedia: (int pcs, MediaType mediaType) {
            final media = [...state.media];
            for (int i = 0; i < pcs; i++) {
              media.add(ReleaseMedia(mediaType: mediaType));
            }
            emit(state.copyWith(
                status: AddOrEditReleaseStatus.mediaAdded, media: media));
            Navigator.pop(context);
          },
          onCancel: () => Navigator.pop(context),
        );
      },
    );
  }

  void _onSetSelectedPicIndex(
    SetSelectedPicIndex event,
    Emitter<AddOrEditReleaseState> emit,
  ) {
    emit(state.copyWith(
      selectedPicIndex: event.selectedPicIndex,
    ));
  }
}
