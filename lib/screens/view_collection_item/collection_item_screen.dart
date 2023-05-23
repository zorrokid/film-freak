import 'package:film_freak/screens/add_or_edit_collection_item/view/add_or_edit_collection_item_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/collection_item_service.dart';
import '../../services/release_service.dart';
import '../../models/collection_item_view_model.dart';
import '../../widgets/error_display_widget.dart';
import '../../widgets/release_data_cards.dart';
import '../../widgets/spinner.dart';
import '../../persistence/app_state.dart';
import 'collection_item_details_card.dart';

class CollectionItemScreen extends StatefulWidget {
  final ReleaseService releaseService;
  final CollectionItemService collectionItemService;
  const CollectionItemScreen({
    required this.id,
    super.key,
    required this.collectionItemService,
    required this.releaseService,
  });

  final int id;

  @override
  State<CollectionItemScreen> createState() {
    return _CollectionItemScreenState();
  }
}

class _CollectionItemScreenState extends State<CollectionItemScreen> {
  // form state
  late Future<CollectionItemViewModel> _futureModel;
  late int? _id;

  @override
  void initState() {
    super.initState();
    _id = widget.id;
    _futureModel = _loadData();
  }

  Future<CollectionItemViewModel> _loadData() async =>
      await widget.collectionItemService.getModel(_id!);

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      return FutureBuilder(
          future: _futureModel,
          builder: (BuildContext context,
              AsyncSnapshot<CollectionItemViewModel> snapshot) {
            if (snapshot.hasError) {
              return ErrorDisplayWidget(snapshot.error.toString());
            }
            if (!snapshot.hasData) {
              return const Spinner();
            }

            final CollectionItemViewModel viewModel = snapshot.data!;

            Future<void> edit() async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddOrEditCollectionItemPage(
                    collectionItemId: viewModel.collectionItem.id,
                    releaseId: viewModel.collectionItem.releaseId!,
                  ),
                ),
              );
              setState(() {
                // refresh the model after edit
                _futureModel = _loadData();
              });
            }

            return Scaffold(
              appBar: AppBar(title: Text(viewModel.releaseModel.release.name)),
              body: ListView(
                padding: const EdgeInsets.only(
                    bottom: kFloatingActionButtonMargin + 48),
                children: [
                  ReleaseDataCards(
                    saveDir: appState.saveDir,
                    viewModel: viewModel.releaseModel,
                    onCollectionItemEdit: (collectionItemId) => edit(),
                  ),
                  CollectionItemDetailsCard(collectionItemViewModel: viewModel)
                ],
              ),
              floatingActionButton: FloatingActionButton(
                onPressed: edit,
                backgroundColor: Colors.green,
                child: const Icon(Icons.edit),
              ),
            );
          });
    });
  }
}
