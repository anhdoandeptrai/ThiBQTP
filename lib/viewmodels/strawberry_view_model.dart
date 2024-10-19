import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:thucpham/models/strawberry.dart';
import 'package:thucpham/services/classification_service.dart';

class StrawberryViewModel extends GetxController {
  var strawberry = Strawberry(imagePath: '', quality: 'Dâu Hư').obs; // Đặt chất lượng mặc định là "Dâu Hư"
  final ClassificationService classificationService = ClassificationService();

  StrawberryViewModel() {
    classificationService.loadModel();
  }

  Future<void> classifyStrawberry(String imagePath) async {
    final quality = await classificationService.classify(imagePath);
    
    // Nếu chất lượng không trả về giá trị hợp lệ, giữ lại "Dâu Hư"
    if (quality.isEmpty) {
      strawberry.value = Strawberry(imagePath: imagePath, quality: 'Dâu Hư');
    } else {
      strawberry.value = Strawberry(imagePath: imagePath, quality: quality);
    }
  }
}
