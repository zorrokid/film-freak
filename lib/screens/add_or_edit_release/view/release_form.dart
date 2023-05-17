import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../domain/enums/media_type.dart';
import '../../../domain/enums/picture_type.dart';
import '../../../widgets/error_display_widget.dart';
import '../../../widgets/picture_type_selection.dart';
import '../../../widgets/spinner.dart';
import '../../../domain/enums/case_type.dart';
import '../../../services/release_service.dart';
import '../../../widgets/form/decorated_text_form_field.dart';
import '../../../widgets/form/dropdown_form_field.dart';
import '../../../widgets/preview_pic.dart';
import '../../../widgets/release_properties.dart';
import '../bloc/add_or_edit_release_bloc.dart';
import '../bloc/add_or_edit_release_event.dart';
import '../bloc/add_or_edit_release_state.dart';
import 'buttons/release_pic_crop.dart';
import 'buttons/release_pic_delete.dart';
import 'buttons/release_pic_selection.dart';
import 'widgets/productions_list.dart';
import 'widgets/release_media_widget.dart';
import 'widgets/media_selector.dart';

class ReleaseForm extends StatefulWidget {
  final String? barcode;
  final int? id;
  final bool addCollectionItem;
  final ReleaseService releaseService;

  const ReleaseForm({
    required this.releaseService,
    this.barcode,
    this.id,
    super.key,
    this.addCollectionItem = false,
  });

  @override
  State<ReleaseForm> createState() {
    return _ReleaseFormState();
  }
}

class _ReleaseFormState extends State<ReleaseForm> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _barcodeController = TextEditingController();
  final _notesController = TextEditingController();
  final _movieSearchTextController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _barcodeController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String? _textInputValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter value';
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AddOrEditReleaseBloc>(context);
    Future<void> submit() async {
      if (!_formKey.currentState!.validate()) return;
      bloc.add(Submit(context, _nameController.text, _barcodeController.text));

      /*if (mounted) {
        if (widget.addCollectionItem) {
          await Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) {
                return CollectionItemForm(
                  releaseId: id,
                  releaseService: widget.releaseService,
                  collectionItemService: initializeCollectionItemService(),
                );
              },
            ),
          );
        } else {
          Navigator.of(context).pop();
        }
      }*/
      Navigator.of(context).pop();
    }

    void selectMedia(BuildContext context, AddOrEditReleaseBloc bloc) {
      showModalBottomSheet(
          context: context,
          builder: (BuildContext context) {
            return MediaSelector(
              onAddMedia: (int pcs, MediaType mediaType) {
                bloc.add(AddMedia(pcs, mediaType));
                Navigator.pop(context);
              },
              onCancel: () => Navigator.pop(context),
            );
          });
    }

    return BlocConsumer<AddOrEditReleaseBloc, AddOrEditReleaseState>(
        listener: (context, state) {
      final bloc = context.read<AddOrEditReleaseBloc>();
      switch (state.status) {
        case AddOrEditReleaseStatus.initialized:
          if (state.id != null) {
            bloc.add(LoadRelease(state.id!));
          } else {
            bloc.add(InitRelease(state.barcode));
          }
          break;
        case AddOrEditReleaseStatus.scanned:
          _barcodeController.text = state.barcode;
          break;
        case AddOrEditReleaseStatus.loaded:
          if (state.viewModel == null) return;
          final viewModel = state.viewModel!;
          _nameController.text = viewModel.release.name;
          _barcodeController.text = viewModel.release.barcode;
          break;
        case AddOrEditReleaseStatus.submitted:
          bloc.add(const DeletePics());
          break;
        case AddOrEditReleaseStatus.picsDeleted:
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
          break;
        case AddOrEditReleaseStatus.imageCropped:
          // TODO are these both needed and is there another way to refresh the image?
          imageCache.clear();
          imageCache.clearLiveImages;
          break;
        default:
        // Nothing to do
      }
    }, builder: (context, state) {
      if (state.errors.isNotEmpty) {
        return ErrorDisplayWidget(state.errors.first);
      }
      if (state.status == AddOrEditReleaseStatus.loading) {
        return const Spinner();
      }

      final bloc = context.read<AddOrEditReleaseBloc>();

      return Scaffold(
        appBar: AppBar(
            title: state.id != null
                ? const Text('Edit release')
                : const Text('Add a new release')),
        body: Form(
          key: _formKey,
          child: ListView(
            children: [
              Row(
                children: [
                  SizedBox(
                      width: 100,
                      child: state.selectedPicIndex > 0
                          ? PreviewPic(
                              releasePicture:
                                  state.pictures[state.selectedPicIndex - 1],
                              saveDirPath: state.saveDir,
                              picTapped: () => bloc.add(const SetPrevPic()),
                            )
                          : null),
                  Expanded(
                    child: state.pictures.isNotEmpty
                        ? PictureTypeSelection(
                            onValueChanged: (PictureType pictureType) =>
                                bloc.add(ChangePicType(pictureType)),
                            releasePicture:
                                state.pictures[state.selectedPicIndex],
                            saveDirPath: state.saveDir,
                          )
                        : const Icon(
                            Icons.image,
                            size: 200,
                          ),
                  ),
                  SizedBox(
                    width: 100,
                    child: state.pictures.length > 1 &&
                            state.selectedPicIndex < state.pictures.length - 1
                        ? PreviewPic(
                            releasePicture:
                                state.pictures[state.selectedPicIndex + 1],
                            saveDirPath: state.saveDir,
                            picTapped: () => bloc.add(const SetNextPic()),
                          )
                        : null,
                  ),
                ],
              ),
              Row(children: [
                Expanded(
                  child: state.pictures.isEmpty
                      ? const Text('No pictures')
                      : Text(
                          '${state.selectedPicIndex + 1}/${state.pictures.length}'),
                ),
                ReleasePictureDelete(
                    onDelete: () => bloc.add(const RemovePic())),
                ReleasePictureCrop(
                    onCropPressed: () => bloc.add(CropPic(context))),
                ReleasePictureSelection(
                    onValueChanged: (String fileName) =>
                        bloc.add(SelectPic(fileName)),
                    saveDir: state.saveDir)
              ]),
              Row(
                children: [
                  Expanded(
                    child: DecoratedTextFormField(
                      controller: _nameController,
                      label: 'Release name',
                      required: true,
                    ),
                  ),
                  IconButton(
                    onPressed: () =>
                        bloc.add(GetImageText(context, _nameController, true)),
                    icon: const Icon(Icons.image),
                  )
                ],
              ),
              ProductionsList(
                productions: state.productions,
                onDelete: (int tmdbId) => bloc.add(RemoveProduction(tmdbId)),
              ),
              Row(
                children: [
                  Expanded(
                    child: DecoratedTextFormField(
                      controller: _movieSearchTextController,
                      label: 'Search movie',
                      required: false,
                    ),
                  ),
                  IconButton(
                    onPressed: () => bloc.add(GetImageText(
                        context, _movieSearchTextController, true)),
                    icon: const Icon(Icons.image),
                  ),
                  IconButton(
                    onPressed: () => bloc.add(SearchProduction(
                        context, _movieSearchTextController.text)),
                    icon: const Icon(Icons.search),
                  ),
                ],
              ),
              DropdownFormField(
                initialValue: state.caseType,
                values: caseTypeFormFieldValues,
                onValueChange: (CaseType? caseType) =>
                    bloc.add(CaseTypeChanged(caseType)),
                labelText: 'Case type',
              ),
              ReleaseMediaWidget(
                releaseMedia: state.media,
              ),
              ElevatedButton(
                onPressed: () => selectMedia(context, bloc),
                child: const Text('Select media'),
              ),
              Row(
                children: [
                  Expanded(
                    child: DecoratedTextFormField(
                      validator: _textInputValidator,
                      controller: _barcodeController,
                      label: 'Barcode',
                      required: true,
                    ),
                  ),
                  IconButton(
                    onPressed: () => bloc.add(ScanBarcode(context)),
                    icon: const Icon(Icons.camera),
                  ),
                ],
              ),
              ReleaseProperties(
                releaseProperties: state.properties,
              ),
              ElevatedButton(
                onPressed: () => bloc.add(SelectProperties(context)),
                child: const Text('Select properties'),
              ),
              Row(
                children: [
                  Expanded(
                    child: DecoratedTextFormField(
                      controller: _notesController,
                      label: 'Notes',
                      required: false,
                      maxLines: 3,
                    ),
                  ),
                  IconButton(
                    onPressed: () => bloc
                        .add(GetImageText(context, _notesController, false)),
                    icon: const Icon(Icons.image),
                  ),
                ],
              ),
              const SizedBox(
                height: 100,
              )
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => submit(),
          backgroundColor: const Color.fromRGBO(76, 175, 80, 1),
          child: const Icon(Icons.save),
        ),
      );
    });
  }
}
