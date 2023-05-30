import 'package:film_freak/screens/add_or_edit_release/pic_viewer.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../domain/enums/picture_type.dart';
import '../../../widgets/error_display_widget.dart';
import '../../../widgets/spinner.dart';
import '../../../domain/enums/case_type.dart';
import '../../../services/release_service.dart';
import '../../../widgets/form/decorated_text_form_field.dart';
import '../../../widgets/form/dropdown_form_field.dart';
import '../../../widgets/release_properties.dart';
import '../bloc/add_or_edit_release_bloc.dart';
import '../bloc/add_or_edit_release_event.dart';
import '../bloc/add_or_edit_release_state.dart';
import 'buttons/release_pic_crop.dart';
import 'buttons/release_pic_delete.dart';
import 'buttons/release_pic_selection.dart';
import 'widgets/productions_list.dart';
import 'widgets/release_media_widget.dart';

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

  Widget buildContent(BuildContext context, AddOrEditReleaseState state) {
    if (state.errors.isNotEmpty) {
      return ErrorDisplayWidget(state.errors.first);
    }
    if (state.status == AddOrEditReleaseStatus.loading) {
      return const Spinner();
    }

    final bloc = BlocProvider.of<AddOrEditReleaseBloc>(context);

    return Form(
      key: _formKey,
      child: ListView(
        children: [
          PicViewer(
            selectedPicIndex: state.selectedPicIndex,
            pictures: state.pictures,
            saveDir: state.saveDir,
            setSelectedPicIndex: (int index) =>
                bloc.add(SetSelectedPicIndex(index)),
            onPictureTypeChanged: (PictureType pictureType) =>
                bloc.add(ChangePicType(pictureType)),
            enableEditing: true,
          ),
          Row(children: [
            Expanded(
              child: state.pictures.isNotEmpty
                  ? Text(
                      '${state.selectedPicIndex + 1}/${state.pictures.length}')
                  : Container(),
            ),
            ReleasePictureDelete(onDelete: () => bloc.add(const RemovePic())),
            ReleasePictureCrop(onCropPressed: () => bloc.add(CropPic(context))),
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
                onPressed: () => bloc.add(
                    GetImageText(context, _movieSearchTextController, true)),
                icon: const Icon(Icons.image),
              ),
              IconButton(
                onPressed: () => bloc.add(
                    SearchProduction(context, _movieSearchTextController.text)),
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
            onPressed: () => bloc.add(SelectMedia(context)),
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
                onPressed: () =>
                    bloc.add(GetImageText(context, _notesController, false)),
                icon: const Icon(Icons.image),
              ),
            ],
          ),
          const SizedBox(
            height: 100,
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bloc = BlocProvider.of<AddOrEditReleaseBloc>(context);

    Future<void> submit() async {
      if (!_formKey.currentState!.validate()) return;
      bloc.add(Submit(context, _nameController.text, _barcodeController.text,
          _notesController.text));
    }

    void stateListener(BuildContext context, AddOrEditReleaseState state) {
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
          _notesController.text = viewModel.release.notes;
          break;
        case AddOrEditReleaseStatus.submitted:
          // Note: if editing a release we can return to either list view or release view.
          // In both cases we need to pass the release id and update the release in calling view.
          // When adding a release, we can only return to the list view.
          Navigator.pop(context, state.viewModel!.release.id);
          break;
        case AddOrEditReleaseStatus.imageCropped:
          // TODO are these both needed and is there another way to refresh the image?
          imageCache.clear();
          imageCache.clearLiveImages;
          break;
        default:
        // Nothing to do
      }
    }

    return BlocConsumer<AddOrEditReleaseBloc, AddOrEditReleaseState>(
        listener: stateListener,
        builder: (context, state) {
          return Scaffold(
            appBar: AppBar(
                title: state.id != null
                    ? const Text('Edit release')
                    : const Text('Add a new release')),
            body: buildContent(context, state),
            floatingActionButton: FloatingActionButton(
              onPressed: () => submit(),
              backgroundColor: Colors.green,
              child: const Icon(Icons.save),
            ),
          );
        });
  }
}
