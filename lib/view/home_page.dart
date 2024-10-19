import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:thucpham/viewmodels/strawberry_view_model.dart';
import 'classification_result_page.dart';

class HomePage extends StatelessWidget {
  final StrawberryViewModel strawberryViewModel = Get.put(StrawberryViewModel());

  Future<void> pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      await _classifyStrawberry(pickedFile.path);
    } else {
      _showError('Vui lòng chọn một hình ảnh.');
    }
  }

  Future<void> _classifyStrawberry(String imagePath) async {
    try {
      await strawberryViewModel.classifyStrawberry(imagePath);
      Get.to(() => ClassificationResultPage());
    } catch (e) {
      _showError('Lỗi phân loại: ${e.toString()}');
    }
  }

  void _showError(String message) {
    Get.defaultDialog(
      title: 'Lỗi',
      middleText: message,
      onConfirm: () => Get.back(),
      textConfirm: 'Đóng',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Phân loại dâu tây'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/strawberry_background.jpg'), // Hình nền
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
            elevation: 8,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Chào mừng đến với ứng dụng phân loại dâu tây!',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: pickImage,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.redAccent, // Màu nút bấm
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                      textStyle: TextStyle(fontSize: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.image, size: 30), // Biểu tượng hình ảnh
                        SizedBox(width: 10),
                        Text('Chọn hình ảnh dâu tây'),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
