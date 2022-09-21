import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'collection_model.dart';

class BarcodeScanner extends StatefulWidget {
  const BarcodeScanner({super.key});

  @override
  State<BarcodeScanner> createState() {
    return _BarcodeScannerState();
  }
}

class _BarcodeScannerState extends State<BarcodeScanner> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CollectionModel>(builder: (context, cart, child) {
      return const Text('scanner');
    });
  }
}
