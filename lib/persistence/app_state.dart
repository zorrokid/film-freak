import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';

class AppStateOld extends ChangeNotifier {
  AppStateOld({required this.saveDir, required this.cameras});
  final List<CameraDescription> cameras;
  final String saveDir;
}
