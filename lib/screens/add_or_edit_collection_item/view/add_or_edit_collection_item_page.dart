import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/collection_item_service.dart';
import '../../../services/release_service.dart';
import '../bloc/add_or_edit_collection_item_bloc.dart';
import '../bloc/add_or_edit_collection_item_event.dart';
import 'collection_item_form.dart';

class AddOrEditCollectionItemPage extends StatelessWidget {
  const AddOrEditCollectionItemPage({
    super.key,
    required this.releaseId,
    this.collectionItemId,
  });

  final int releaseId;
  final int? collectionItemId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) {
        final bloc = AddOrEditCollectionItemBloc(
          context.read<CollectionItemService>(),
        );
        bloc.add(InitState(releaseId, collectionItemId));
        return bloc;
      },
      child: CollectionItemForm(
        releaseService: context.read<ReleaseService>(),
        collectionItemService: context.read<CollectionItemService>(),
        releaseId: releaseId,
        id: collectionItemId,
      ),
    );
  }
}
