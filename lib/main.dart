import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:thucpham/services/classification_service.dart';
import 'package:thucpham/view/login_page.dart'; // Nhập trang đăng nhập

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final classificationService = ClassificationService();
  await classificationService.loadModel();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Phân loại dâu tây',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(), // Đặt trang đăng nhập làm trang chính
      debugShowCheckedModeBanner: false,
    );
  }
}
