import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thucpham/models/strawberry.dart';
import 'package:thucpham/services/classification_service.dart';
import 'package:thucpham/viewmodels/strawberry_view_model.dart';
import 'package:image/image.dart' as img;

class ClassificationResultPage extends StatelessWidget {
  final StrawberryViewModel strawberryViewModel = Get.find();
  final ClassificationService classificationService = ClassificationService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Kết quả phân loại'),
        backgroundColor: Colors.green[800],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/strawberry_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Obx(() {
            final strawberry = strawberryViewModel.strawberry.value;

            // Thiết lập chất lượng mặc định là "Dâu Hư"
            String quality = strawberry.quality.isEmpty ? "Dâu Hư" : strawberry.quality;

            if (strawberry.imagePath.isEmpty) {
              return CircularProgressIndicator();
            }

            final imageFile = File(strawberry.imagePath);
            img.Image image = img.decodeImage(imageFile.readAsBytesSync())!;
            bool isSpoiled = classificationService.detectSpoilage(image);
            String colorQuality = classificationService.checkColorQuality(image);
            String firmnessQuality = classificationService.checkFirmness(image);

            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildImageContainer(imageFile),
                  _buildInfoContainer(strawberry, isSpoiled, colorQuality, firmnessQuality, quality),
                ],
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildImageContainer(File imageFile) {
    return Container(
      margin: EdgeInsets.all(16.0),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10.0),
        child: Image.file(
          imageFile,
          height: 300,
          width: 300,
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildInfoContainer(Strawberry strawberry, bool isSpoiled, String colorQuality, String firmnessQuality, String quality) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(15.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 10.0,
            offset: Offset(0, 5),
          ),
        ],
      ),
      padding: EdgeInsets.all(20.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Kết quả phân loại',
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.green[800]),
          ),
          SizedBox(height: 10),
          Text('Chất lượng: $quality', style: TextStyle(fontSize: 20)),
          SizedBox(height: 10),
          _buildSpoilageRow(isSpoiled),
          SizedBox(height: 10),
          Text('Màu sắc: $colorQuality', style: TextStyle(fontSize: 20)),
          SizedBox(height: 10),
          Text('Độ cứng: $firmnessQuality', style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }

  Widget _buildSpoilageRow(bool isSpoiled) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Hư hỏng:', style: TextStyle(fontSize: 20)),
        // Thiết lập thông tin "Không ăn được" nếu hư hỏng
        Text(isSpoiled ? 'Ăn được' : 'Không ăn được', style: TextStyle(fontSize: 20)),
        Icon(isSpoiled ? Icons.warning : Icons.check, color: isSpoiled ? Colors.red : Colors.green),
      ],
    );
  }
}
