import 'package:flutter/material.dart';
import 'loginpage.dart';
import 'package:permission_handler/permission_handler.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});
  
  @override
  _MainappState createState() => _MainappState();
}


class _MainappState extends State<MainApp> {


@override
  void initState() {
    super.initState();
  WidgetsBinding.instance.addPostFrameCallback((_) {
    requestStoragePermission();
  });
}

//when the user launch the application it pop up storage request permession
Future<void> requestStoragePermission() async {
  final status = await Permission.storage.request();
  if (status.isGranted) {
    
  } else {
    
  }
}



  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: Loginpage(),
      debugShowCheckedModeBanner: false,
    );
  }



}
