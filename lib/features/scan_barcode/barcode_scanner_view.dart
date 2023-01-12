import 'package:flutter/material.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';
import 'package:provider/provider.dart';
import '../../persistence/app_state.dart';
import '../../screens/camera_view.dart';

class BarcodeScannerView extends StatefulWidget {
  const BarcodeScannerView({super.key});
  @override
  State<BarcodeScannerView> createState() => _BarcodeScannerViewState();
}

class _BarcodeScannerViewState extends State<BarcodeScannerView> {
  final BarcodeScanner _barcodeScanner = BarcodeScanner();
  bool _isBusy = false;
  bool _isReady = false;

  @override
  void dispose() {
    _isReady = true;
    _barcodeScanner.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AppState>(builder: (context, appState, child) {
      return CameraView(
        title: 'Barcode Scanner',
        onImage: (inputImage) async {
          processImage(inputImage);
        },
        cameras: appState.cameras,
      );
    });
  }

  Future<void> processImage(InputImage inputImage) async {
    // If we're done scanning or busy scanning previous image, no point continuing
    if (_isReady || _isBusy) return;
    _isBusy = true;
    final barcodes = await _barcodeScanner.processImage(inputImage);
    if (mounted && barcodes.isNotEmpty) {
      _isReady = true;
      // Navigate back along with first scanned barcode value as return value
      Navigator.of(context).pop(barcodes.first.rawValue);
    }
    _isBusy = false;
  }
}
