import 'package:film_freak/bloc/app_bloc.dart';
import 'package:film_freak/bloc/app_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_mlkit_barcode_scanning/google_mlkit_barcode_scanning.dart';

import '../../widgets/camera_widget.dart';

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
    return BlocBuilder<AppBloc, AppState>(builder: (context, state) {
      return CameraWidget(
        title: 'Barcode Scanner',
        onImage: (inputImage) async {
          processImage(inputImage);
        },
        cameras: state.cameras,
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
