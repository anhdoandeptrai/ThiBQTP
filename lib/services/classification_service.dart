import 'dart:io';
import 'package:tflite/tflite.dart';
import 'package:image/image.dart' as img;
import 'package:thucpham/bindings/binding.dart';

class ClassificationService {
  Future<void> loadModel() async {
    try {
      await AppBinding.loadModel();
    } catch (e) {
      print("Error loading model: Dâu Hư");
    }
  }

  Future<String> classify(String imagePath) async {
    try {
      final resizedImagePath = await _resizeImage(imagePath);
      final result = await Tflite.runModelOnImage(
        path: resizedImagePath,
        imageMean: 127.5,
        imageStd: 127.5,
        numResults: 2,
        threshold: 0.5,
      );

      if (result != null && result.isNotEmpty) {
        return result[0]['label'];
      } else {
        return 'Không thể phân loại';
      }
    } catch (e) {
      print("Error during classification: $e");
      return 'Dâu Hư';
    }
  }

  Future<String> _resizeImage(String imagePath) async {
    File imageFile = File(imagePath);
    img.Image originalImage = img.decodeImage(imageFile.readAsBytesSync())!;
    img.Image resizedImage = img.copyResize(originalImage, width: 150, height: 150);

    String resizedImagePath = '${imageFile.path}_resized.jpg';
    File(resizedImagePath).writeAsBytesSync(img.encodeJpg(resizedImage));
    return resizedImagePath;
  }

  bool detectSpoilage(img.Image image) {
    // Logic phát hiện hư hỏng ở đây
    return false;
  }

  String checkColorQuality(img.Image image) {
    // Logic kiểm tra màu sắc ở đây
    int totalR = 0, totalG = 0, totalB = 0;

    for (int y = 0; y < image.height; y++) {
      for (int x = 0; x < image.width; x++) {
        var pixel = image.getPixel(x, y);
        totalR += img.getRed(pixel);
        totalG += img.getGreen(pixel);
        totalB += img.getBlue(pixel);
      }
    }

    int totalPixels = image.width * image.height;
    int avgR = totalR ~/ totalPixels;
    int avgG = totalG ~/ totalPixels;
    int avgB = totalB ~/ totalPixels;

    return (avgR > 200 && avgG < 150 && avgB < 150) ? 'Màu sắc đạt yêu cầu (Đỏ)' : 'Màu sắc không đạt yêu cầu';
  }

  String checkFirmness(img.Image image) {
    // Logic kiểm tra độ cứng ở đây
    return 'Độ cứng đạt yêu cầu';
  }
}
