import 'package:flutter/widgets.dart';
import 'package:tflite/tflite.dart';

class AppBinding {
  static Future<void> initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await loadModel();
  }

  static Future<void> loadModel() async {
    try {
      String? res = await Tflite.loadModel(
        model: "assets/strawberry_classifier.tflite",
        labels: "assets/labels.txt",
      );
      print('Model loaded: $res');
    } catch (e) {
      print("Error loading TFLite model: $e");
    }
  }
}
